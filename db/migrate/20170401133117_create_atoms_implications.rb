class CreateAtomsImplications < ActiveRecord::Migration[5.0]
  def change
    create_table :atoms_implications, id: false do |t|
      t.references :atom, foreign_key: true
      t.references :implication, foreign_key: true
    end
  end
end
