class RemoveSuperfluousStructureColumnInAtoms < ActiveRecord::Migration[5.0]
  def change
    remove_column :atoms, :structure_id
  end
end
