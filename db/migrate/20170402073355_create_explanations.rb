class CreateExplanations < ActiveRecord::Migration[5.0]
  def change
    create_table :explanations do |t|
      t.string :title
      t.text :text
      t.references :explainable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
