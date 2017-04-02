class SaneBuildingBlockRealizations < ActiveModel::Validator
  def validate(bbr)
    if bbr.building_block.structure != bbr.realization.structure
      bbr.errors[:base] << "Mismatch between BuildingBlockRealization BB "
      bbr.errors[:base] << "Structure and its Realization"
    end
  end
end


class BuildingBlockRealization < ApplicationRecord
  belongs_to :example
  belongs_to :building_block
  belongs_to :realization, class_name: 'Example'

  validates :example, presence: true
  validates :building_block, presence: true
  validates :realization, presence: true
  validates_with SaneBuildingBlockRealizations

end
