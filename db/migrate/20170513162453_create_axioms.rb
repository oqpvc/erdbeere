class CreateAxioms < ActiveRecord::Migration[5.0]
  def change
    create_table :axioms do |t|
      t.references :structure, foreign_key: true
      t.references :atom, foreign_key: true

      t.timestamps
    end
  end
end
