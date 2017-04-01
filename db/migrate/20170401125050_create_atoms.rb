class CreateAtoms < ActiveRecord::Migration[5.0]
  def change
    create_table :atoms do |t|
      t.references :structure, foreign_key: true
      t.references :stuff_w_props, polymorphic: true, index:true
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
