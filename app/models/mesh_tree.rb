class MeshTree < ActiveRecord::Base
  belongs_to :subject
  belongs_to :parent, :class_name => "MeshTree", :foreign_key => :parent_id
  
  def self.children(parent_id = nil)
    MeshTree.find_all_by_parent_id(parent_id, :include => [:subject => :subject_stats], :order => :id)
  end
  
  def children
    MeshTree.find_all_by_parent_id(id, :include => [:subject => :subject_stats], :order => :id)
  end

  def ancestors
    current = self
    ancestor = []
    while current.nil? == false do
      parent = current.parent
      current = parent
      ancestor.push(parent) unless parent.nil?
    end
    ancestor.reverse
  end
end
