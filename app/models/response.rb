class Response < ActiveRecord::Base
  has_one :question
  acts_as_list :scope => :question
	
  belongs_to :possible_response

  validates_presence_of :question_id, :possible_response_id
	
  validates_uniqueness_of :possible_response_id, :scope => :question_id
	
  attr_accessor :should_destroy
	
  def should_destroy?
    should_destroy.to_i == 1
  end
end
