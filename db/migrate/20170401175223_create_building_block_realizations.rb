class CreateBuildingBlockRealizations < ActiveRecord::Migration[5.0]
  def change
    create_table :building_block_realizations do |t|
      t.references :example, foreign_key: true
      t.references :building_block, foreign_key: true
      t.references :realization, foreign_key: true

      t.timestamps
    end
  end
end
