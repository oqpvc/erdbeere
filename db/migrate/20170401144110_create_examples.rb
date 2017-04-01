class CreateExamples < ActiveRecord::Migration[5.0]
  def change
    create_table :examples do |t|
      t.text :explanation
      t.references :structure, foreign_key: true

      t.timestamps
    end
  end
end
