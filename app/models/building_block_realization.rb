class BuildingBlockRealization < ApplicationRecord
  belongs_to :example, touch: true
  belongs_to :building_block
  belongs_to :realization, class_name: 'Example'

  validates :example, presence: true
  validates :building_block, presence: true
  validates :realization, presence: true
  validates_with EqualityTest, a: 'building_block.structure', b: 'realization.structure'
end
