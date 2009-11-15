class MeshTree < ActiveRecord::Base
  belongs_to :subject
  
  def self.children(parent_id = 0)
    MeshTree.find_all_by_parent_id(parent_id, :include => [:subject => :subject_stats])
  end
end
