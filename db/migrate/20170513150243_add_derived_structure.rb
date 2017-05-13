class AddDerivedStructure < ActiveRecord::Migration[5.0]
  def change
    add_reference :structures, :derives_from, foreign_key: {to_table: :structures}
  end
end
