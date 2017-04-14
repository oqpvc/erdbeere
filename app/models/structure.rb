class Structure < ApplicationRecord
  has_many :properties
  has_many :examples
  has_many :building_blocks, foreign_key: 'explained_structure_id',
    inverse_of: :explained_structure

  has_many :atoms, as: :stuff_w_props
  has_many :building_blocks, inverse_of: :structure

  def structure
    self
  end
end
