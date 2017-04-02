class Implication < ApplicationRecord
  has_and_belongs_to_many :atoms
  belongs_to :implies, class_name: 'Atom'
  has_many :explanations, as: :explainable

  validates :implies, presence: true

  def to_s
    base_struct = implies.stuff_w_props.structure
    s = "*IF* "
    s << self.atoms.map { |a| '(' + a.to_s + ')' }.join(" *AND* ")
    s << " *THEN* #{base_struct.name} *IS* #{implies.property.name}"
    s
  end
end
