class SalesPerson < ActiveRecord::Base
  belongs_to :state # Sales person has a state in his contact info.
  belongs_to :user # Sales person belongs to a User that is the authentication credentials for the sales person.
  has_many :contractors # Sales person has many Contractors that are the contractors for which he is responsible.
  has_many :orders
  has_many :payments
  has_many :bonuses

  before_validation :copy_user_fields
  after_destroy :destroy_user

  attr_accessor :password, :password_confirmation

  validates_presence_of :first_name, :last_name, :phone, :commission_rate_new_account, :commission_rate_reorder, :commission_rate_renewal
  validates_numericality_of [:commission_rate_new_account, :commission_rate_reorder, :commission_rate_renewal], :greater_than_or_equal => 0, :less_than_or_equal => 100, :message => "must be a number between 0 and 100."
  
  validates_length_of :fax, :in => 7..25, :allow_nil => true, :allow_blank => true
  validates_length_of :phone, :in => 7..25
  validates_length_of :mobile, :in => 7..25, :allow_nil => true, :allow_blank => true
  validates_length_of :postal_code, :in => 3..5, :allow_nil => true, :allow_blank => true
  
  def name
    self.first_name + " " + self.last_name
  end
  
  def commission
    self.orders.sum(:commission).to_f
  end

  def paid_commission
    self.payments.sum(:amount, :conditions => ["type='CommissionPayment'"]).to_f
  end

  def accessible_commission
    self.orders.sum(:commission, :joins => "INNER JOIN payments ON payments.order_id = orders.id", :conditions => ["commission_payment_id IS NULL"]).to_f + 
      self.bonuses.sum(:amount, :conditions => ["payment_id IS NULL"]).to_f
  end
  
  def self.find_active_sales_person
    find(:all, :joins => "inner join users on sales_people.user_id = users.id", :conditions => ["state = ?", "active"])
  end
protected

  def copy_user_fields
    self.login = self.user.login
    self.email = self.user.email
  end

  def destroy_user
    self.user.destroy if self.user
  end
end
