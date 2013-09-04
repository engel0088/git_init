class Contractor < ActiveRecord::Base
  include Paranoid
  i_am_paranoid
  
  INSURANCE_EXPIRES_SOON_DAYS = 60
  HOME_IMPROVEMENT_EXPO_ID = 1735
  
  belongs_to :state # Contractor has a state in his contact info.
  belongs_to :user # Contractor belongs to a User that is the authentication credentials for the sales person.
  belongs_to :sales_person, :counter_cache => true # Contractor belongs to a particular sales person that is taking care of it.
  belongs_to :mobile_carrier
  has_many :monopolies
  #has_many :wished_monopolies
  has_many :leads
  has_many :orders


  before_validation :copy_user_fields, :check_for_no_logo
  
  after_destroy :destroy_dependencies
  # [TODO] file_column
=begin
  file_column :logo , :magick => { 
    :versions => { "standard" => "120x500>" }
  }
=end

  attr_accessor :password, :password_confirmation, :no_logo

  validates_presence_of :first_name, :last_name, :phone
  
  validates_length_of :fax, :in => 7..15, :allow_nil => true, :allow_blank => true
  validates_length_of :phone, :in => 7..15
  validates_length_of :mobile, :in => 7..15, :allow_nil => true, :allow_blank => true
  validates_length_of :postal_code, :in => 3..5, :allow_nil => true, :allow_blank => true
  
  def name
    self.first_name + " " + self.last_name
  end

  acts_as_state_machine :initial => :active, :column => 'status'
  state :active, :enter => Proc.new {|c| c.user.activate! if c.user} # Make sure user authentication credentials also follow the Active/Suspended status
  state :suspended, :enter => Proc.new {|c| c.user.suspend! if c.user}

  event :activate do
    transitions :from => :suspended, :to => :active 
  end
  
  event :suspend do
    transitions :from => :active, :to => :suspended
  end

  def wished_monopolies(page = -1)
    if page.to_i < 0
      WishedMonopoly.find(:all, :conditions => ["contractor_id = ?", self.id])
    else
      WishedMonopoly.find(:all, :page => {:size => 20, :current => page.to_i}, :conditions => ["contractor_id = ?", self.id])
    end
  end


  def wished_monopolies_list(limit = false)
    
    Monopoly.find(:all, :joins => "INNER JOIN wished_monopolies ON monopolies.id = wished_monopolies.monopoly_id", :include => [:zip_code, :category], :conditions => ["wished_monopolies.contractor_id = ?", self.id], :order => "zip_codes.code")
  end

  def clear_wished_monopolies(save_unavailable = false)
    self.wished_monopolies.each {|m| m.destroy if !save_unavailable || m.monopoly.available?}
  end


  def add_wished_monopolies(zips, category)
    Wished
    
  end


  def add_wished_monopoly(category_id, zip_code_id)
    
    wish = WishedMonopoly.find(:first, :joins => "INNER JOIN monopolies ON wished_monopolies.monopoly_id = monopolies.id", :conditions => ["wished_monopolies.contractor_id = ? AND monopolies.zip_code_id = ? AND monopolies.category_id = ?", self.id, zip_code_id, category_id])
    
    unless wish
      wish = WishedMonopoly.new(:contractor_id => self.id)
      wish.zip_code_id = zip_code_id
      wish.category_id = category_id
      wish.save
    end
  end

  def payments
    Payment.find(:all, :include => [:order], :conditions => ["orders.contractor_id = ?", self.id])
  end
  
  def insurance_expiring?
    return false unless self.date_insured_to
    (self.date_insured_to - Date.today) < INSURANCE_EXPIRES_SOON_DAYS
  end
  
  def insurance_expires_in?(days)
    (self.date_insured_to - Date.today) == days
  end
  
  def categories
    Category.find(:all, :conditions => ["monopolies.contractor_id = ?", self.id], :joins => "INNER JOIN monopolies ON monopolies.category_id = categories.id", :group => "categories.id")
  end
  

  def monopoly_soonest_expiration
    soonest = nil
    monopolies.each do |m|
      soonest = m.expiration if soonest.nil? || (m.expiration < soonest && m.expiration >= Date.today)
    end
    soonest
  end
  
  def latest_order
    orders.find(:first, :order => "created_at DESC")
  end

protected

  def check_for_no_logo
    self.logo = nil if self.no_logo == "1"
  end


  def copy_user_fields
    if self.user
      #self.login = self.user.login
      self.user.email = self.email
    end
  end

  def destroy_dependencies
    #debugger
    self.user.delete! if self.user
    self.monopolies.each { |mono| mono.deactivate! }
    self.wished_monopolies.each { |mono| mono.destroy }
    #self.leads.each { |lead| lead.destroy }
  end

#  def destroy_user
#    self.user.destroy if self.user
#  end

  
end
