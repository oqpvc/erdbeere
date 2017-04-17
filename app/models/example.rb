class Example < ApplicationRecord
  has_many :example_truths
  has_many :building_block_realizations
  belongs_to :structure
  has_many :explanations, as: :explainable
  has_many :appearances_as_building_block_realizations, class_name: "BuildingBlockRealization", foreign_key: 'example_id'

  validates :structure, presence: true
  before_save :touch_appearances_as_building_block_realizations

  translates :description, :fallbacks_for_empty_translations => true
  globalize_accessors

  def touch_appearances_as_building_block_realizations
    appearances_as_building_block_realizations.each do |bbr|
      bbr.touch
    end
  end

  def hardcoded_flat_truths
    example_truths.find_all { |t| t.satisfied == true }.map { |t| t.property.to_atom }
  end

  def hardcoded_flat_falsehoods
     example_truths.find_all { |t| t.satisfied == false }.map { |t| t.property.to_atom }
  end

  def hardcoded_flat_truths_as_properties
    self.hardcoded_flat_truths.map { |a| a.property }
  end

  def hardcoded_falsehoods_as_properties
    self.hardcoded_flat_falsehoods.map { |a| a.property }
  end

  def facts(test = true)
    a = []
    if not building_block_realizations.blank?
      a += building_block_realizations.map do |bbr|
        sub_facts = bbr.realization.facts(test)
        # those sub truths are now of the wrong type: the resulting Atoms have
        # stuff_w_props = bbr.realization.structure, not the building block we want!
        sub_facts.map do |st|
          Atom.find_or_create_by({stuff_w_props: bbr.building_block, property: st.property})
        end
      end
    end

    a += example_truths.to_a.find_all { |et| et.satisfied == test }.map do |et|
      Atom.find_or_create_by({stuff_w_props: structure, property: et.property})
    end.to_a

    a.flatten
  end

  def hardcoded_truths
    facts
  end

  def satisfied_atoms
    facts.all_that_follows
  end

  def satisfied_atoms_with_implications
    facts.all_that_follows_with_implications
  end

  def hardcoded_falsehoods
    facts(false)
  end

  # this is really expensive! use with care!
  def violated_properties(with_implications = false)
    sat = satisfied_atoms
    exclusions = sat.find_all do |a|
      a.stuff_w_props == structure
    end.map { |a| a.property_id }

    exclusions += hardcoded_falsehoods_as_properties.map { |p| p.id }

    props = Property.where('structure_id = ?', structure.id)
    props = props.where.not(id: exclusions)

    if with_implications
      bad_props = []
      used_implications = {}
      props.to_a.each do |p|
        nsat_w_i = (sat + [p.to_atom]).all_that_follows_with_implications
        unless (nsat_w_i.first & hardcoded_falsehoods).empty?
          violated_atom = (nsat_w_i.first & hardcoded_falsehoods).first
          used_implications[p] = nsat_w_i.second.key(violated_atom)
          bad_props.push(p)
        end
      end
      return [bad_props, used_implications]
    else
      props.to_a.find_all do |p|
        nsat = (sat + [p.to_atom]).all_that_follows
        (nsat & hardcoded_falsehoods).empty?
      end
    end
  end

  def computable_violations
    computable_violations_with_implications.first
  end

  def computable_violations_with_implications
    r = violated_properties(with_implications: true)
    r.first.map! do |p|
      p.to_atom
    end
    r.push(hardcoded_falsehoods)
    r
  end

  def satisfies?(atom)
    # atom might be a property
    atom = atom.kind_of?(Property) ? atom.to_atom : atom

    satisfied_atoms.include?(atom)
  end

  def violates?(atom)
    # might be a property
    atom = atom.kind_of?(Property) ? atom.to_atom : atom
    computable_violations.include?(atom)
  end

  def satisfies!(atom)
    set_truth(atom, true)
  end

  def violates!(atom)
    set_truth(atom, false)
  end

  def set_truth(atom, value)
    if atom.kind_of?(Array)
      atom.each do |a|
        set_truth(a, value)
      end
    elsif atom.kind_of?(Property)
      set_truth(atom.to_atom, value)
    else
      methods = {true => 'satisfies?', false => 'violates?'}
      raise 'not implemented' unless atom.stuff_w_props == structure
      raise "already set to #{not value}" if self.send(methods[(not value)], atom)
      ExampleTruth.find_or_create_by({example: self, property: atom.property, satisfied: value})
    end
  end
end
