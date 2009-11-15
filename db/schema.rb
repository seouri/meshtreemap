# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091113080743) do

  create_table "mesh_trees", :force => true do |t|
    t.string  "tree_number"
    t.integer "subject_id"
    t.integer "parent_id"
  end

  add_index "mesh_trees", ["parent_id"], :name => "index_mesh_trees_on_parent_id"

  create_table "subject_stats", :force => true do |t|
    t.integer "subject_id"
    t.string  "year"
    t.integer "self_count",       :default => 0
    t.integer "descendant_count", :default => 0
  end

  add_index "subject_stats", ["subject_id", "year"], :name => "index_subject_stats_on_subject_id_and_year"

  create_table "subjects", :force => true do |t|
    t.string "term"
  end

end
