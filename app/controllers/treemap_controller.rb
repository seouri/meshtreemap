class TreemapController < ApplicationController
  def index
    @tree_id = params[:id]
    @tree = MeshTree.find(@tree_id) unless @tree_id.nil?
    @year = params[:year] || "all"
  end
end
