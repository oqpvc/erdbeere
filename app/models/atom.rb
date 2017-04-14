# coding: utf-8
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
    "#{self.stuff_w_props.name} *IS* #{property.name}"
  end

  # call follows_from?(atom1, atom2, …) or follows_from?([atom1, atom2, …])
  def follows_from?(*atoms)
    if atoms.length == 1 && atoms.first.kind_of?(Array) then
      atoms = atoms.first
    end

    atoms.all_that_follows.include?(self)
  end
end

