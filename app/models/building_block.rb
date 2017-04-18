class BuildingBlock < ApplicationRecord
  belongs_to :explained_structure, class_name: 'Structure', foreign_key: 'explained_structure_id'
  belongs_to :structure
  has_many :atoms, as: :stuff_w_props

  validates :explained_structure, presence: true
  validates :structure, presence: true

  translates :name, :definition, fallbacks_for_empty_translations: true
  globalize_accessors
end
