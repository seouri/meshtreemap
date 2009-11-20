class SubjectStat < ActiveRecord::Base
  belongs_to :subject
  named_scope :year, lambda { |year| { :conditions => { :year => year } } }

  def self.years
    SubjectStat.find(:all, :select => "distinct year").map {|s| s.year}
  end
end
