class AtomImplications2Premises < ActiveRecord::Migration[5.0]
  def change
    rename_table :atoms_implications, :premises
    add_column :premises, :id, :primary_key
  end
end
