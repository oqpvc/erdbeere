class RenameExampleTruths2Facts < ActiveRecord::Migration[5.0]
  def change
    rename_table :example_truths, :example_facts
  end
end
