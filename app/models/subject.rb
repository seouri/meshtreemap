class Subject < ActiveRecord::Base
  has_many :subject_stats
  has_many :mesh_trees
end
