class CreateSatifies < ActiveRecord::Migration[5.0]
  def up
    change_table :atoms do |t|
      t.rename :property_id, :satisfies_id
      t.string :satisfies_type
      t.index [:satisfies_type, :satisfies_id]
      execute <<-SQL
        UPDATE atoms SET satisfies_type = 'Property'
      SQL
    end
  end

  def down
    change_table :atoms do |t|
      execute <<-SQL
        DELETE FROM atoms WHERE satisfies_type != 'Property'
      SQL
      t.rename :satisfies_id, :property_id
      t.remove_column :satisfies_type
    end
  end
end
