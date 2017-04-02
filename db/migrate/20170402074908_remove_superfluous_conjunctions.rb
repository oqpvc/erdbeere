class RemoveSuperfluousConjunctions < ActiveRecord::Migration[5.0]
  def change
    remove_column :implications, :conjunction_id
  end
end
