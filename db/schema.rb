# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170416151529) do

  create_table "atoms", force: :cascade do |t|
    t.string   "stuff_w_props_type"
    t.integer  "stuff_w_props_id"
    t.integer  "property_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["property_id"], name: "index_atoms_on_property_id"
    t.index ["stuff_w_props_type", "stuff_w_props_id"], name: "index_atoms_on_stuff_w_props_type_and_stuff_w_props_id"
  end

  create_table "atoms_implications", id: false, force: :cascade do |t|
    t.integer "atom_id"
    t.integer "implication_id"
    t.index ["atom_id"], name: "index_atoms_implications_on_atom_id"
    t.index ["implication_id"], name: "index_atoms_implications_on_implication_id"
  end

  create_table "building_block_realizations", force: :cascade do |t|
    t.integer  "example_id"
    t.integer  "building_block_id"
    t.integer  "realization_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["building_block_id"], name: "index_building_block_realizations_on_building_block_id"
    t.index ["example_id"], name: "index_building_block_realizations_on_example_id"
    t.index ["realization_id"], name: "index_building_block_realizations_on_realization_id"
  end

  create_table "building_block_translations", force: :cascade do |t|
    t.integer  "building_block_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.text     "definition"
    t.index ["building_block_id"], name: "index_building_block_translations_on_building_block_id"
    t.index ["locale"], name: "index_building_block_translations_on_locale"
  end

  create_table "building_blocks", force: :cascade do |t|
    t.integer  "explained_structure_id"
    t.integer  "structure_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["explained_structure_id"], name: "index_building_blocks_on_explained_structure_id"
    t.index ["structure_id"], name: "index_building_blocks_on_structure_id"
  end

  create_table "example_translations", force: :cascade do |t|
    t.integer  "example_id",  null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.index ["example_id"], name: "index_example_translations_on_example_id"
    t.index ["locale"], name: "index_example_translations_on_locale"
  end

  create_table "example_truths", force: :cascade do |t|
    t.integer  "example_id"
    t.integer  "property_id"
    t.boolean  "satisfied"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["example_id"], name: "index_example_truths_on_example_id"
    t.index ["property_id"], name: "index_example_truths_on_property_id"
  end

  create_table "examples", force: :cascade do |t|
    t.integer  "structure_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["structure_id"], name: "index_examples_on_structure_id"
  end

  create_table "explanations", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.string   "explainable_type"
    t.integer  "explainable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["explainable_type", "explainable_id"], name: "index_explanations_on_explainable_type_and_explainable_id"
  end

  create_table "implications", force: :cascade do |t|
    t.integer  "implies_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["implies_id"], name: "index_implications_on_implies_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "structure_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["structure_id"], name: "index_properties_on_structure_id"
  end

  create_table "property_translations", force: :cascade do |t|
    t.integer  "property_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "definition"
    t.index ["locale"], name: "index_property_translations_on_locale"
    t.index ["property_id"], name: "index_property_translations_on_property_id"
  end

  create_table "structure_translations", force: :cascade do |t|
    t.integer  "structure_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.text     "definition"
    t.index ["locale"], name: "index_structure_translations_on_locale"
    t.index ["structure_id"], name: "index_structure_translations_on_structure_id"
  end

  create_table "structures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
