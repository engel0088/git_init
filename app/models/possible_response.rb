class PossibleResponse < ActiveRecord::Base
  has_many :responses
	has_many :questions, :through => :responses, :foreign_key => "possible_response_id"
	
	validates_presence_of :response
	validates_uniqueness_of :response

end
