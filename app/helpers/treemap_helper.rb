module TreemapHelper
  def treelist(tree, year = "all")
    list = content_tag(:ul, (tree.nil? ? MeshTree : tree).children.select {|c| c.subject_stats.year(year)[0].nil? == false && c.subject_stats.year(year)[0].total_count > 0}.map {|c| content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id, :year => year)), :id => "mesh_tree_#{c.id}")}.join("\n"))
    unless tree.nil?
      current = content_tag(:ul, content_tag(:li, content_tag(:strong, tree.subject.term) + list, :id => "mesh_tree_#{tree.id}"))
      list = tree.ancestors.reverse.inject(current) {|html, c|  content_tag(:ul, content_tag(:li, link_to(c.subject.term, treemap_path(:id => c.id, :year => year)) + "\n" + html, :id => "mesh_tree_#{c.id}"))}
    end
    list = link_to_unless_current("<strong>MeSH</strong>", treemap_path(:year => year, :id => nil)) + list
    content_tag(:div, list, :id => "mesh_tree_list")
  end

  def treemap(tree, year = "all")
    json = ""
    root = ""
    tree_id = {}
    children = {}
    (tree.nil? ? MeshTree : tree).children.select {|c| c.subject_stats.year(year)[0].nil? == false && c.subject_stats.year(year)[0].total_count > 0}.each {|c| children[c.subject.term] = c.subject_stats.year(year)[0].total_count; tree_id[c.subject.term.gsub(/[ ,]+/, '_')] = c.id}
    if tree.nil?
      json =  children.to_json
      root = "MeSH"
    else
      tree_id["parent_node"] = tree.parent_id if tree.parent_id
      tree_id[tree.subject.term.gsub(/[ ,]+/, '_')] = tree.id
      root = tree.subject.term
      ys = tree.subject_stats.year(year)[0]
      self_count = ys.nil? ? 0 : ys.self_count
      desc_count = ys.nil? ? 0 : ys.descendant_count
      if desc_count > 0
        children[tree.subject.term] = self_count if self_count > 0
        json = children.to_json
      elsif self_count > 0
        json = {tree.subject.term, self_count}.to_json
      end
    end

    mesh = "var mesh = " + json
    js = <<END
<div id="treemap">
    <script type="text/javascript+protovis">
      var tree_id = #{tree_id.to_json}
      #{mesh}
      var color = pv.Colors.category20().by(function(n) n.keys.slice(0, -1) + 3);
      color = pv.colors("lightgray", "white").by(function(n) n.keys.slice(0, -1))

      var vis = new pv.Panel()
        .def("i", -1)
        .width(663)
        .height(400);

      vis.add(pv.Bar)
        .extend(pv.Layout.treemap(mesh).root("#{root}").round(true).inset(14, 2, 2, 2))
        .width(function(n) n.width - 2)
        .height(function(n) n.height - 2)
        .cursor("pointer")
        .event("click", function(n) {
            var id = ""
            if (this.index == 0 && tree_id["parent_node"]) {
              id = tree_id["parent_node"];
            }
            if(this.index > 0) {
              id = tree_id[n.keys[1].replace(/[ ,]+/g, '_')];
            }
            top.location = "/treemap/#{year}/" + id;
          })
        .event("mouseover", function(n) {
            vis.i(this.index);
            if(this.index > 0) {
              var id = "mesh_tree_" + tree_id[n.keys[1].replace(/[ ,]+/g, '_')];
              $('#mesh_tree_list li').each(function() {
                if (this.id == id) {
                  $(this).addClass('highlight');
                }
              });
            }
            return vis;
          })
        .event("mouseout", function(n) {
            vis.i(-1);
            if(this.index > 0) {
              var id = "mesh_tree_" + tree_id[n.keys[1].replace(/[ ,]+/g, '_')];
              $('#mesh_tree_list li').removeClass('highlight');
            }
            return vis;
          })
        .fillStyle(function(n) vis.i() == this.index && this.index > 0 ? "#CEF" : color(n))
        .title(function(n) n.keys[n.keys.length - 1] + ": " + (n.data || ""))
        .anchor("top").add(pv.Label)
          .font(function(n) this.index == 0 ? "10px sans-serif" : "12px sans-serif")
          .textStyle(function(n) vis.i() == this.index ? "black" : "rgba(0,0,0," + this.fillStyle().opacity + ")")
          .text(function(n) n.keys[n.keys.length - 1].length > parseInt(n.width / 9) ? n.keys[n.keys.length - 1].substring(0, parseInt(n.width / 9)) + " ..." : n.keys[n.keys.length - 1])
          .anchor("bottom").add(pv.Label)
            .textStyle(function(n) vis.i() == this.index && n.height > 22 ? "#555" : "rgba(0, 0, 0, 0)")
            .text(function(n) this.index > 0 ? n.data : "");
      vis.render();

    </script>
</div>
END
  end
end
