# coding: utf-8

class Atom < ApplicationRecord
  has_many :premises
  has_many :implications, through: :premises

  belongs_to :stuff_w_props, polymorphic: true
  belongs_to :satisfies, polymorphic: true
  has_many :atoms, as: :satisfies

  validates :stuff_w_props, presence: true
  validates :satisfies, presence: true
  validates :satisfies_id, uniqueness: { scope: [:stuff_w_props, :satisfies_type] }
  validates_with EqualityTest, a: 'satisfies.structure', b: 'stuff_w_props.structure'

  after_commit :touch_potentially_relevant_examples

  def touch_potentially_relevant_examples
    Example.where(structure: satisfies.structure).map(&:touch)
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

  def structure
    stuff_w_props.structure
  end

  def property
    nil unless satisfies.is_a?(Property)
    satisfies
  end
end
