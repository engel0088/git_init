class Order < ActiveRecord::Base
  #encrypt :credit_card_number 
  
  EXPIRES_SOON_DAYS = 60
  TYPES = ["NewAccountOrder", "ReOrder", "RenewalOrder"]


  acts_as_state_machine :initial => :pending, :column => 'status'
  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  validates_numericality_of :discount, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :commission, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_presence_of :monopolies, :message => "- You need to select at least one zip code."
  belongs_to :contractor
  belongs_to :sales_person
  belongs_to :billing_state, :class_name => 'State'
  belongs_to :original_order, :class_name => 'Order'
  #has_many :order_monopolies
  has_and_belongs_to_many :monopolies
  belongs_to :payment, :foreign_key => "commission_payment_id"
  has_many :payments
  has_many :order_changes

  # attr_accessor :monopolies
  attr_accessor :credit_card_expiration, :commission_rate

  after_create :clear_wishlist
  
  before_save :compute_amount_total
  
  state :pending
  state :active
  state :canceled
  
  event :commit do
    transitions :from => :pending, :to => :active
  end
  
  event :cancel do
    transitions :from => :pending, :to => :canceled
  end


  def contractor
    Contractor.find_with_deleted(self.contractor_id)
  end


  def credit_card_expiration
    self.credit_card_month_exp.to_s + "/" + credit_card_year_exp.to_s
  end
  
  def commit # rename to activate!
    transaction do
      monos = Monopoly.find(:all, :joins => "INNER JOIN monopolies_orders ON monopolies_orders.monopoly_id = monopolies.id", :conditions => ["monopolies_orders.order_id = ?", self.id], :readonly => false)      
      #monos = self.monopolies.find(:all, :readonly => false)
      monos.each do |mono|
        #raise Monopoly::MonopolyAlreadyTaken.new if Monopoly.exists?(["id = ? AND expiration >= ? AND contractor_id IS NOT NULL", mono.id, self.start_date])

        mono.activate!(self.contractor, self.start_date, self.end_date)
      end
      self.commit!
      SMS.send_text(self.contractor.mobile, Setting.get("SMS_TO_CONTRACTOR_ORDER_ACTIVATION")) if self.contractor.mobile
    end
    true
  end

  def rollback # rename to deactivate!
    transaction do
      monos = Monopoly.find(:all, :joins => "INNER JOIN monopolies_orders ON monopolies_orders.monopoly_id = monopolies.id", :conditions => ["monopolies_orders.order_id = ?", self.id], :readonly => false)      
#debugger
      #monos = self.monopolies.find(:all, :readonly => false)
      monos.each do |mono|        
        mono.deactivate!
      end
      self.status = "pending"
      self.save!
    end
  end

  def estimate_cost
    cost = 0
    self.contractor.wished_monopolies.each do |m|
      cost += Monopoly::PRICE #if m.monopoly.available?(self.start_date)
    end
    cost
  end

  def estimate_commission
    if self.amount
      return self.sales_person ? self.amount * (self.effective_commission_rate / 100.0) : 0.0
    else
      return self.sales_person ? self.estimate_cost * (self.effective_commission_rate / 100.0) : 0.0
    end
  end

  def available?
    
    av = true
    monopolies.each {|m| av &= m.available?}
    av
  end

  def expires_soon?
    self.end_date - Date.today <= EXPIRES_SOON_DAYS
  end
  
  def expires_in(number_days)
    self.end_date && (self.end_date - Date.today == number_days)
  end
  
  def expired?
    Date.today > self.end_date
  end

  def agreement_sent?
    self.agreement_sent_at != nil
  end

  def effective_commission_rate
    0 # Defined by subclasses
  end

  def commission_paid?
    self.commission_payment_id != nil
  end

  def pay_commission!(payment)
    self.update_attribute(:commission_payment_id, payment.id)
  end

  
  def replace_monopolies(new_monopolies)
    @num = 0
      
    transaction do
      num_monopolies = self.monopolies.size
      checksum = 0
      deactivated = []
      activated = []
      self.monopolies.each do |monopoly|
        #debugger
        unless new_monopolies.include?(monopoly)
          monopoly.deactivate!
          deactivated << monopoly
          #self.monopolies.delete(monopoly) 
          checksum -= 1
        end        
      end  
      new_monopolies.each do |monopoly|
        #debugger
        unless self.monopolies.include?(monopoly)
          monopoly.activate!(self.contractor, Date.today, self.end_date)
          #self.monopolies << monopoly
          activated << monopoly
          checksum += 1
          @num += 1
        end
      end
      deactivated.each { |d| self.monopolies.delete(d) }
      activated.each { |a| self.monopolies << a }
      raise "Houston we have a problem! #{checksum}" if checksum != 0
    end
    return @num
  end
  
  #def create_order_monopolies
    #self.contractor.wished_monopolies.each { |c| OrderMonopoly.create(:order_id => self.id, :monopoly_id => c.monopoly_id) }
  #  self.monopolies.each do |mid| 
  #    OrderMonopoly.create(:order_id => self.id, :monopoly_id => mid) 
  #    self.contractor.wished_monopolies.find(:first, :conditions => ["monopoly_id = ?", mid]).destroy
  #  end
  #end
  def owned?(user)
    user.has_role?('admin') || (user.has_role?('sales_person') && user.sales_person.id == self.sales_person_id)
  end
  
  
  def compute_amount_total
    self.amount_total = self.amount.to_f - self.discount.to_f
  end
  
  def credit_card_number
    key = EzCrypto::Key.with_password "password", "system salt"
    key.decrypt(read_attribute(:credit_card_number))
  end
  
  def credit_card_number=(value)
    key = EzCrypto::Key.with_password "password", "system salt"
    write_attribute(:credit_card_number, key.encrypt(value))
  end
  
  
  #def total
  #  self.amount.to_f - self.discount.to_f
  #end
  
  #def total=(amount)
    # do nothing
  #end
  
protected
  def clear_wishlist
    self.contractor.clear_wished_monopolies(true)
  end
  
end

# The first order for a contractor
class NewAccountOrder < Order
  def effective_commission_rate
    self.sales_person.commission_rate_new_account if self.sales_person
  end
end

# Order for a contractor that has already ordered.
class ReOrder < Order
  def effective_commission_rate
    self.sales_person.commission_rate_reorder if self.sales_person
  end
end

# Order that is created as the renewal of an existing order
class RenewalOrder < Order
  attr_accessor :renewed_order

  def estimate_cost
    return Monopoly::PRICE * @renewed_order.monopolies.size
  end

  def effective_commission_rate
    self.sales_person.commission_rate_renewal if self.sales_person  
  end
end
