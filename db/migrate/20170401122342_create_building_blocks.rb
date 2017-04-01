class CreateBuildingBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :building_blocks do |t|
      t.string :name
      t.text :definition
      t.references :explained_structure, foreign_key: true
      t.references :structure, foreign_key: true

      t.timestamps
    end
  end
end
