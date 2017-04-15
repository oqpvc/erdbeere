class Property < ApplicationRecord
  belongs_to :structure

  validates :structure, presence: true

  translates :name, :definition, :fallbacks_for_empty_translations => true
  globalize_accessors

  def to_atom(stuff_w_props = self.structure)
    Atom.find_or_create_by({stuff_w_props: stuff_w_props,
                                      property: self})
  end
end
