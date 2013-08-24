class Questionnaire < ActiveRecord::Base
  belongs_to :project_type
  
  has_many :questions, :order => "position", :dependent => :destroy
	
  validates_presence_of :name

end
