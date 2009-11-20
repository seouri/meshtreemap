class CreateSubjectStats < ActiveRecord::Migration
  def self.up
    create_table :subject_stats do |t|
      t.integer :subject_id
      t.string  :year
      t.integer :self_count, :default => 0
      t.integer :descendant_count, :default => 0
    end
    add_index :subject_stats, [:subject_id, :year]
    add_index :subject_stats, :year
  end

  def self.down
    drop_table :subject_stats
  end
end
