class SaneAtoms < ActiveModel::Validator
  def validate(atom)
    if atom.property.structure != atom.stuff_w_props.structure
      atom.errors[:base] << "Mismatch between property and structure"
    end
  end
end

class Atom < ApplicationRecord
  has_and_belongs_to_many :implications

  belongs_to :stuff_w_props, polymorphic: true
  belongs_to :property

  validates :stuff_w_props, presence: true
  validates :property, presence: true
  validates_with SaneAtoms
  validates :property, :uniqueness => { :scope => :stuff_w_props }

  def to_s
    s = ""
    s << "#{self.stuff_w_props.name} *IS* #{property.name}"
    s
  end

  # call or follows_from?(atom1, atom2, …) follows_from?([atom1, atom2, …])
  def follows_from?(*atoms)
    if atoms.length == 1 && atoms.first.kind_of?(Array) then
      atoms = atoms.first
    end

    all_the_atoms_that_follow =
    until_stable(method(:follows_in_one_iteration), atoms)
    all_the_atoms_that_follow.include?(self)
  end

  def follows_in_one_iteration(atoms)
    # TODO this is probably the slowest implementation possible. is
    # there a more efficient way that still looks like rails?
    one_iteration = Implication.all.to_a.find_all do |i|
      (i.atoms - atoms).empty?
    end.map do |i|
      i.implies
    end

    (atoms + one_iteration).uniq
  end

  # if not called with an upper limit, this runs forever!
  def until_stable(function, seed, iterations = -1)
    if iterations == 0
      return seed
    end

    tmp = seed
    seed = function.call(seed)
    if tmp == seed
      seed
    else
      until_stable(function, seed, iterations-1)
    end
  end
end
