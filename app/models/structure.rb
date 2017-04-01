class Structure < ApplicationRecord
  has_many :properties
  has_many :building_blocks, foreign_key: 'explained_structure_id'
  has_many :atoms, as: :stuff_w_props
end
