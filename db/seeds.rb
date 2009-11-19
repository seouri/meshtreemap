# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
subjects_file = File.join(File.dirname(__FILE__), 'desc.txt')
if File.stat(subjects_file).size > 0  
  File.foreach(subjects_file) do |record|
    s = Subject.new
    s.id, s.term, trees = record.chomp.split("\t")
    s.save!
  end
end

subject_stats_file = File.join(File.dirname(__FILE__), 'subject_stats.dat')
if File.stat(subject_stats_file).size > 0  
  File.foreach(subject_stats_file) do |record|
    s = SubjectStat.new
    s.id, s.subject_id, s.year, s.self_count, s.descendant_count = record.chomp.split("\t")
    s.save!
  end
end

mesh_trees_file = File.join(File.dirname(__FILE__), 'mesh_trees.dat')
if File.stat(mesh_trees_file).size > 0  
  File.foreach(mesh_trees_file) do |record|
    s = MeshTree.new
    s.id, s.tree_number, s.subject_id, s.parent_id = record.chomp.split("\t")
    s.save!
  end
end
