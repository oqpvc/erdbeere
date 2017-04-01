class BuildingBlockRealization < ApplicationRecord
  belongs_to :example
  belongs_to :building_block
  belongs_to :realization, class_name: 'Example'
end
