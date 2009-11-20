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
    json = ""
    root = ""
    children = {}
    (tree.nil? ? MeshTree : tree).children.select {|c| c.subject_stats.year(year)[0].nil? == false && c.subject_stats.year(year)[0].total_count > 0}.each {|c| children[c.subject.term] = c.subject_stats.year(year)[0].total_count}
    if tree.nil?
      json =  children.to_json
      root = "MeSH"
    else
      root = tree.subject.term
      self_count = tree.subject_stats.year(year)[0].self_count
      desc_count = tree.subject_stats.year(year)[0].descendant_count
      if desc_count > 0
        children[tree.subject.term] = self_count if self_count > 0
        json = children.to_json
      elsif self_count > 0
        json = {tree.subject.term, self_count}.to_json
      end
    end
    mesh = "var mesh = " + json
    js = <<END
    <script type="text/javascript+protovis">
      #{mesh}
      var color = pv.Colors.category19().by(function(n) n.keys.slice(0, -1));

      var vis = new pv.Panel()
        .width(600)
        .height(600);

      vis.add(pv.Bar)
        .extend(pv.Layout.treemap(mesh).root("#{root}").round(true).inset(14, 4, 4, 4))
        .width(function(n) n.width - 2)
        .height(function(n) n.height - 2)
        .fillStyle(function(n) color(n))
        .title(function(n) n.keys.join(".") + ": " + n.data)
        .anchor("top").add(pv.Label)
        .textStyle(function() "rgba(0,0,0," + this.fillStyle().opacity + ")")
        .text(function(n) n.keys.length <= 3 ? n.keys[n.keys.length - 1] : "");
      vis.render();

    </script>
END
  end
end
