class SubjectStat < ActiveRecord::Base
  belongs_to :subject
  named_scope :year, lambda { |year| { :conditions => { :year => year } } }
end
