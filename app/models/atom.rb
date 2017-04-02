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

  def to_s
    s = ""
    s << "#{self.stuff_w_props.name} *IS* #{property.name}"
    s
  end
end
