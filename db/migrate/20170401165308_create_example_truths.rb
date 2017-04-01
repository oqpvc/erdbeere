class CreateExampleTruths < ActiveRecord::Migration[5.0]
  def change
    create_table :example_truths do |t|
      t.references :example, foreign_key: true
      t.references :property, foreign_key: true
      t.boolean :satisfied

      t.timestamps
    end
  end
end
