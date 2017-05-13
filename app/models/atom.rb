# coding: utf-8

class AtomValidator < ActiveModel::Validator
  def validate(a)
    if a.satisfies.is_a?(Property)
      return if a.satisfies.structure == a.stuff_w_props.structure
      a.errors[:base] << 'Type mismatch between satisfies.structure and stuff_w_props.structure'
    elsif a.satisfies.is_a?(Atom)
      return if a.stuff_w_props.structure.building_blocks.map(&:structure).include?(a.satisfies.structure)
      a.errors[:base] << 'There is no building block that matches satisfies.structure'
    else
      a.errors[:base] << 'Something srsly fucked up happened'
    end
  end
end

class Atom < ApplicationRecord
  has_many :premises
  has_many :implications, through: :premises

  belongs_to :stuff_w_props, polymorphic: true
  belongs_to :satisfies, polymorphic: true
  has_many :atoms, as: :satisfies

  validates :stuff_w_props, presence: true
  validates :satisfies, presence: true
  validates :satisfies_id, uniqueness: { scope: [:stuff_w_props, :satisfies_type] }
  validates_with AtomValidator

  after_commit :touch_potentially_relevant_examples
  after_create :create_trivial_implications

  def create_trivial_implications
    if satisfies.is_a?(Atom)
      satisfies.implies! self
    end
  end

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
