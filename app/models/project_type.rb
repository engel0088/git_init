class ProjectType < ActiveRecord::Base
  has_one :questionnaire #, :dependent => :destroy
  #belongs_to :category
  has_many :lead
  
  i_am_paranoid
  
  validates_presence_of :name, :message => "can't be blank"

  after_create :create_questionnaire
  after_save :update_questionnaire_name

  def before_save
    self.permalink = self.name.downcase.gsub(/[^a-z0-9]+/i, '-')

    i = 2
    while ProjectType.find(:first, :conditions => ["permalink = ? AND id != ?", self.permalink, self.id])
      self.permalink += i.to_s
      i += 1
    end    
  end

  def category
    self.category_id ? Category.find_with_deleted(self.category_id) : nil
  end



  def create_questionnaire
    Questionnaire.create(:project_type_id => self.id, :name => "#{self.name} Questionnaire")
  end

  def update_questionnaire_name
    self.questionnaire.update_attribute(:name, "#{self.name} Questionnaire") if self.questionnaire
  end

end
