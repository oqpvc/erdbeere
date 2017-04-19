# coding: utf-8

class Atom < ApplicationRecord
  has_many :premises
  has_many :implications, through: :premises

  belongs_to :stuff_w_props, polymorphic: true
  belongs_to :property

  validates :stuff_w_props, presence: true
  validates :property, presence: true
  validates_with EqualityTest, a: 'property.structure', b: 'stuff_w_props.structure'
  validates :property, uniqueness: { scope: :stuff_w_props }

  after_commit :touch_potentially_relevant_examples

  def touch_potentially_relevant_examples
    Example.where(structure: property.structure).map(&:touch)
  end

  def to_s
    "#{stuff_w_props.name} *IS* #{property.name}"
  end

  # call follows_from?(atom1, atom2, …) or follows_from?([atom1, atom2, …])
  def follows_from?(*atoms)
    atoms = atoms.first if atoms.length == 1 && atoms.first.is_a?(Array)

    atoms.all_that_follows.include?(self)
  end

  def implies!(atom)
    [self].implies!(atom)
  end

  def is_equivalent!(atoms)
    [self].is_equivalent! atoms
  end
end
