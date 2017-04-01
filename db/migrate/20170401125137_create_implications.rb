class CreateImplications < ActiveRecord::Migration[5.0]
  def change
    create_table :implications do |t|
      t.references :conjunction, foreign_key: true
      t.references :implies, foreign_key: true

      t.timestamps
    end
  end
end
