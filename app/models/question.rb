class Question < ActiveRecord::Base
  belongs_to :questionnaire
	acts_as_list :scope => :questionnaire
	
	belongs_to :question_type
	has_many :responses, :order => "position ASC", :dependent => :destroy
	has_many :possible_responses, :through => :responses, :foreign_key => "question_id", :order => "response ASC"
	
	has_many :anonymous_questionnaires
	
	validates_associated :possible_responses
	validates_presence_of :name, :question_type_id
	
	after_update :save_responses
	
# Function which create or update responses of a question	
	def response_attributes=(response_attributes)
		response_attributes.each do |attributes|
			response = responses.detect { |t| t.id == attributes[:id].to_i}
			
			# Search if response exist
			@possible_response = PossibleResponse.find(:first, :conditions => ['response = ?', attributes[:response]])
			# If not, created it
			if !@possible_response
				@possible_response = PossibleResponse.new(:response => attributes[:response])
				@possible_response.save
			end
			
			# Delete :response and add :possible_response_id fields
			attributes.delete(:response)
			attributes[:possible_response_id] = @possible_response.id
			# Update the attribute or create a new one
			if attributes[:id].blank?
				responses.build(attributes)
			else
				response.attributes = attributes
			end
		end
	end

# Function which save or destroy previous responses created or updated.	
	def save_responses
		responses.each do |t|		
			if t.should_destroy?
				t.destroy
			else
				t.save(false)
			end
		end
	end
end
