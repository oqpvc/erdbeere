class RenameExampleExplanation2Description < ActiveRecord::Migration[5.0]
  def change
    rename_column :example_translations, :explanation, :description
  end
end
