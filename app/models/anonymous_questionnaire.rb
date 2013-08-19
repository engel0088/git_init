class AnonymousQuestionnaire < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :questionnaire
  belongs_to :lead
  belongs_to :question
  
  validates_presence_of :question_id, :on => :create, :message => "can't be blank"

end
