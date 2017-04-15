class TranslateData < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        BuildingBlock.create_translation_table!({
                                                  :name => :string,
                                                  :definition => :text
                                                 }, {
                                                  :migrate_data => true,
                                                  :remove_source_columns => true
                                                })
        Example.create_translation_table!({
                                            :explanation => :text
                                          }, {
                                            :migrate_data => true,
                                            :remove_source_columns => true
                                          })
        Property.create_translation_table!({
                                             :name => :string,
                                             :definition => :text
                                           }, {
                                             :migrate_data => true,
                                             :remove_source_columns => true
                                           })
        Structure.create_translation_table!({
                                              :name => :string,
                                              :definition => :text
                                            }, {
                                              :migrate_data => true,
                                              :remove_source_columns => true
                                            })
      end

      dir.down do
        BuildingBlock.drop_translation_table! :migrate_data => true
        Example.drop_translation_table! :migrate_data => true
        Property.drop_translation_table! :migrate_data => true
        Structure.drop_translation_table! :migrate_data => true
      end
    end
  end
end
