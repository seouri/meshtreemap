module TreemapHelper
  def treelist(tree)
    if tree.nil?
      content_tag(:ul, MeshTree.children.map {|c| content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id)), :id => "mesh_tree_id_#{c.id}")}.join("\n"))
    else
      children = content_tag(:ul, (tree.nil? ? MeshTree : tree).children.map {|c| content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id)), :id => "mesh_tree_id_#{c.id}")}.join("\n"))
      current = content_tag(:ul, content_tag(:li, tree.subject.term + children, :id => "mesh_tree_id_#{tree.id}"))
      tree.ancestors.reverse.inject(current) {|html, c|  content_tag(:ul, content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id)) + "\n" + html, :id => "mesh_tree_id_#{c.id}"))}
    end
  end
  
  def treemap(tree, year = "all")
    children = (tree.nil? ? MeshTree : tree).children.select {|c| c.subject.subject_stats.year(year)[0].nil? == false && c.subject.subject_stats.year(year)[0].descendant_count > 0}.map {|c| {c.subject.term, c.subject.subject_stats.year(year)[0].descendant_count}}
    unless tree.nil?
      self_count = tree.subject.subject_stats.year(year)[0].self_count
      if self_count > 0
        children.push({tree.subject.term, self_count})
      end
    end
    {"T", children}.to_json
  end
end
