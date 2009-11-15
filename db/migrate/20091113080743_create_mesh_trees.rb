class CreateMeshTrees < ActiveRecord::Migration
  def self.up
    create_table :mesh_trees do |t|
      t.string  :tree_number
      t.integer :subject_id
      t.integer :parent_id
    end
    add_index :mesh_trees, :parent_id
  end

  def self.down
    drop_table :mesh_trees
  end
end
