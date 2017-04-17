class Example < ApplicationRecord
  has_many :example_truths
  has_many :building_block_realizations
  belongs_to :structure
  has_many :explanations, as: :explainable

  validates :structure, presence: true

  translates :description, :fallbacks_for_empty_translations => true
  globalize_accessors

  def satisfied
    example_truths.find_all { |t| t.satisfied == true }.map { |t| t.property }
  end

  def violated
    example_truths.find_all { |t| t.satisfied == false }.map { |t| t.property }
  end

  def atoms_from_example_truths
    truths(:itself)
  end

  def all_that_is_satisfied
    all_that_is_true
  end

  def all_that_is_satisfied_with_implications
    self.truths.all_that_follows_with_implications
  end

  def all_that_is_true
    truths(:all_that_follows)
  end

  def all_that_is_violated
    truths(:itself, false)
  end

  def falsehoods
    example_truths.where(satisfied: false).map { |f| f.property.to_atom }
  end

  def truths(fn = :itself, test = true)
    a = []
    if not building_block_realizations.blank?
      a += building_block_realizations.map do |bbr|
        sub_truths = bbr.realization.truths(fn, test)
        # those sub truths are now of the wrong type: the resulting Atoms have
        # stuff_w_props = bbr.realization.structure, not the building block we want!
        sub_truths.map do |st|
          Atom.find_or_create_by({stuff_w_props: bbr.building_block, property: st.property})
        end
      end
    end

    a += example_truths.to_a.find_all { |et| et.satisfied == test }.map do |et|
      Atom.find_or_create_by({stuff_w_props: structure, property: et.property})
    end.to_a.send(fn)

    a.flatten.send(fn)
  end

  def satisfies?(atom)
    # atom might be a property
    atom = atom.kind_of?(Property) ? atom.to_atom : atom

    all_that_is_true.include?(atom)
  end

  def violates?(atom)
    # atom might be a property
    atom = atom.kind_of?(Property) ? atom.to_atom : atom

    all_that_is_violated.include?(atom)
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
        self.set_truth(a, value)
      end
    elsif atom.kind_of?(Property)
      self.set_truth(atom.to_atom, value)
    else
      methods = {true => 'satisfies?', false => 'violates?'}
      raise 'not implemented' unless atom.stuff_w_props == self.structure
      raise "already set to #{not value}" if self.send(methods[(not value)], atom)
      ExampleTruth.find_or_create_by({example: self, property: atom.property, satisfied: value})
    end
  end
end
