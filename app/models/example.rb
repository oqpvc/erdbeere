class Example < ApplicationRecord
  include CacheIt
  has_many :example_facts
  has_many :building_block_realizations
  belongs_to :structure
  has_many :explanations, as: :explainable
  has_many :appearances_as_building_block_realizations, class_name: 'BuildingBlockRealization', foreign_key: 'realization_id'

  validates :structure, presence: true
  after_commit :touch_appearances_as_building_block_realizations

  translates :description, fallbacks_for_empty_translations: true
  globalize_accessors

  def touch_appearances_as_building_block_realizations
    appearances_as_building_block_realizations.each(&:touch)
  end

  def hardcoded_flat_truths
    example_facts.find_all { |t| t.satisfied == true }.map { |t| t.property.to_atom } + structure.defining_atoms
  end

  def hardcoded_flat_falsehoods
    example_facts.find_all { |t| t.satisfied == false }.map { |t| t.property.to_atom }
  end

  def hardcoded_flat_truths_as_properties
    # TODO deep atoms
    hardcoded_flat_truths.map(&:property)
  end

  def hardcoded_falsehoods_as_properties
    # TODO deep atoms
    hardcoded_flat_falsehoods.map(&:property)
  end

  def facts(test: [true, false])
    a = []
    if building_block_realizations.present?
      a += building_block_realizations.map do |bbr|
        sub_facts = bbr.realization.facts(test: test)
        # those sub facts are now of the wrong type: the resulting Atoms have
        # stuff_w_props = bbr.realization.structure, not the building block we want!
        sub_facts.map do |st|
          if st.stuff_w_props.is_a?(Structure)
            Atom.find_or_create_by(stuff_w_props: bbr.building_block, satisfies: st.satisfies)
          else
            st
          end
        end
      end
    end

    a += example_facts.where(satisfied: test).map do |et|
      Atom.find_or_create_by(stuff_w_props: structure, satisfies: et.property)
    end.to_a

    if (test.is_a?(Array) && test.include?(true)) || test === true
      a += structure.defining_atoms
    end

    a.flatten
  end

  def hardcoded_truths
    facts(test: true)
  end
  cache_it :hardcoded_truths

  def satisfied_atoms
    facts(test: true).all_that_follows
  end
  cache_it :satisfied_atoms

  def satisfied_atoms_with_implications
    facts(test: true).all_that_follows_with_implications
  end
  cache_it :satisfied_atoms_with_implications

  def hardcoded_falsehoods
    facts(test: false)
  end
  cache_it :hardcoded_falsehoods

  # this is really expensive! use with care!
  def violated_properties(with_implications: false)
    sat = satisfied_atoms

    # TODO deep atoms
    exclusions = sat.to_a.find_all do |a|
      a.stuff_w_props == structure
    end.map(&:satisfies_id)

    exclusions += hardcoded_falsehoods_as_properties.map(&:id)

    props = Property.where('structure_id = ?', structure.id)
    props = props.where.not(id: exclusions)

    return [[], {}] if (props.count.zero? && with_implications)
    return [] if props.count.zero?

    if with_implications == true
      bad_props = []
      used_implications = {}
      props.to_a.each do |p|
        nsat_w_i = (sat + [p.to_atom]).all_that_follows_with_implications
        next if (nsat_w_i.first & hardcoded_falsehoods).empty?
        violated_atom = (nsat_w_i.first & hardcoded_falsehoods).first
        used_implications[nsat_w_i.second.key(violated_atom)] = p.to_atom
        bad_props.push(p)
      end
      return [bad_props, used_implications]
    else
      props.to_a.find_all do |p|
        nsat = (sat + [p.to_atom]).all_that_follows
        !(nsat & hardcoded_falsehoods).empty?
      end
    end
  end

  def computable_violations
    vp = violated_properties(with_implications: false)
    return hardcoded_falsehoods if vp.empty?

    vp.map(&:to_atom) + hardcoded_falsehoods
  end
  cache_it :computable_violations

  def computable_violations_with_implications
    r = violated_properties(with_implications: true)
    r.first.map!(&:to_atom)
    [(r.first + hardcoded_falsehoods).uniq, r.second]
  end
  cache_it :computable_violations_with_implications

  def satisfies?(atom)
    # atom might be a property
    atom = atom.is_a?(Property) ? atom.to_atom : atom

    satisfied_atoms.include?(atom)
  end

  def violates?(atom)
    # might be a property
    atom = atom.is_a?(Property) ? atom.to_atom : atom
    computable_violations.include?(atom)
  end

  def satisfies!(atom)
    set_truth(atom, true)
  end

  def violates!(atom)
    set_truth(atom, false)
  end

  def set_truth(atom, value)
    if atom.is_a?(Array)
      atom.each do |a|
        set_truth(a, value)
      end
    elsif atom.is_a?(Property)
      set_truth(atom.to_atom, value)
    else
      methods = { true => 'satisfies?', false => 'violates?' }
      raise 'not implemented' unless atom.stuff_w_props == structure
      raise "already set to #{!value}" if send(methods[!value], atom)
      ExampleFact.find_or_create_by(example: self, property: atom.property, satisfied: value)
    end
  end
end
