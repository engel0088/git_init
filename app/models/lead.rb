class Lead < ActiveRecord::Base
  i_am_paranoid
  #belongs_to :project_type
  has_many :anonymous_questionnaires, :dependent => :destroy
  belongs_to :contractor
  belongs_to :financer, :class_name => 'Contractor'
  belongs_to :state
  #belongs_to :category
  
  validates_presence_of :name, :email
  validates_presence_of :category_id
  
  #validates_length_of :phone, :in => 7..15
  validates_length_of :email, :within => 3..100
 # validates_length_of :postal_code, :in => 3..5

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'must be valid'
  

  before_validation :assign_category_id
  after_update :save_responses
  before_create :assign_contractor, :assign_financer, :assign_guid
  after_create :send_notifications
  
  #attr_accessor :category_id
  
  def project_type
    
    self.project_type_id ? ProjectType.find_with_deleted(self.project_type_id) : nil  
  rescue ActiveRecord::RecordNotFound => e
    nil    
  end
  
  
  def category
  
    #return Category.find(category_id) unless category_id.nil?
    return Category.find_with_deleted(self.category_id) if self.category_id    
    return self.project_type.category.top if self.project_type
  
  rescue ActiveRecord::RecordNotFound => e
    nil    
  end
  
  def validate
    unless zip_code = ZipCode.find_by_code(self.postal_code)
      errors.add(:postal_code, "<b>#{self.postal_code}</b> is not a valid US zip code in our database (3 to 5 digits)")
    else
      assign_state_id(zip_code)
    end
    
    ph = self.phone.to_s.gsub(/[^\d]/, '')
    if ph.size < 10
      errors.add(:phone, "<b>#{self.phone}</b> is not a valid US phone number (it must contain at least 10 digits)")
    elsif ph.size > 15
      errors.add(:phone, "<b>#{self.phone}</b> is too long (maximum is 15 characters)")      
    end    
  end
  
  
  def contractor
    Contractor.find_with_deleted(self.contractor_id)
  end
  
  #def contractor_with_deleted
  #  Contractor.find_with_deleted(self.contractor_id)
  #end

  def questionnaire=(questionnaire)
      questionnaire.each do |question_id, response|
        # anonymous_response = anonymous_response.detect { |t| t.id == attributes[:id].to_i}
          @question_type = Question.find(question_id).question_type
          case @question_type.id
            when 5
              response_text = response
              response = response_text["(4i)"] + ":" + response_text["(5i)"]
            when 8            
              response = response.join(", ")
          end

          # Update only responses entered by the user
          if !response.empty? && response != "Please Select"
            anonymous_questionnaires.build(:question_id => question_id, :response_text => response)
          end
      end
  end
  
  
# Function which save or destroy previous responses created or updated.	
  def save_responses
    unless self.deleted?
      anonymous_questionnaires.each do |t|		
        #if t.should_destroy? JSB: This method does not seem to exist
        #  t.destroy
        #else
          t.save(false)
        #end
      end
    end
  end
        
  def assign_contractor
    self.contractor = Monopoly.match_contractor(self)        
  end
  
  def assign_financer
    self.financer = Monopoly.match_financer(self) if self.financing
  end
  
  def assign_guid
    self.guid = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  def assign_category_id
    self.category_id = self.project_type.category.top.id if self.project_type
  end
  
  def assign_state_id(zip_code)
    self.state = State.find_by_code(zip_code.state_code)    
  end
        
  def send_notifications
    #debugger
    text = "HIE #{self.category.name} (#{self.project_type ? "full-form" : "mini-form"}): #{self.name}(#{self.phone}) #{self.call_me}" #Setting.get("SMS_TO_CONTRACTOR_NEW_LEAD")

    if self.contractor
      Notification.deliver_new_lead(self.contractor, self)    
      SMS.send_text(self.contractor.mobile, text) if self.contractor.mobile
    end  
    if self.financer
      Notification.deliver_new_lead(self.financer, self)
      SMS.send_text(self.financer.mobile, text) if self.financer.mobile
    end
  end
  
end
