class Property < ApplicationRecord
  belongs_to :structure

  validates :structure, presence: true

  def to_atom
    Atom.find_or_create_by({stuff_w_props: self.structure,
                                      property: self})
  end
end
