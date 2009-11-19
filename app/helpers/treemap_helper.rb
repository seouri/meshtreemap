module TreemapHelper
  def treelist(tree)
    if tree.nil?
      content_tag(:ul, MeshTree.children.map {|c| content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id)), :id => "mesh_tree_id_#{c.id}")}.join("\n"))
    else
      children = content_tag(:ul, tree.children.map {|c| content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id)), :id => "mesh_tree_id_#{c.id}")}.join("\n"))
      current = content_tag(:ul, content_tag(:li, tree.subject.term + children, :id => "mesh_tree_id_#{tree.id}"))
      tree.ancestors.reverse.inject(current) {|html, c|  content_tag(:ul, content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id)) + "\n" + html, :id => "mesh_tree_id_#{c.id}"))}
    end
  end
  
  def treemap(tree, year = "all")
    if tree.nil?
      children = MeshTree.children.select {|c| c.subject.subject_stats.year(year) }.map {|c| c.subject.subject_stats.year(year)[0].self_count}
    else
      tree.children.select {|c| c.subject.subject_stats.year(year)}.map {|c| c.subject.subject_stats.year(year)[0].self_count}.join("|")
    end
  end
end
