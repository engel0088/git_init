class Payment < ActiveRecord::Base
  METHODS = ["master", "visa", "amex", "discover", "other"]
  belongs_to :order
  has_many :orders
  has_many :bonuses
  validates_numericality_of :amount, :greater_than => 0

  def first_name
    self.billing_name.split()[0]
  end

  def last_name
    self.billing_name.split()[1...self.billing_name.split().size].join(" ")
  end
  
  def total_amount
    self.amount.to_i - self.discount.to_i
  end
  
  def credit_card?
    METHODS[0..3].include?(self.payment_method.to_s.downcase)
  end




  def create_cc  
    ActiveMerchant::Billing::CreditCard.new(
      :number => self.credit_card_number,
      :verification_value => self.credit_card_cvv,
      :month => self.credit_card_month_exp,
      :year => self.credit_card_year_exp,
      :first_name => self.first_name,
      :last_name => self.last_name
    )
  end
  
  def options
    self.billing_state_id.to_i > 0 ? state = State.find(self.billing_state_id.to_i).name : state = ""

    options = {:address => {},
      :billing_address => { 
        :name     => self.billing_name,
        :address1 => self.billing_address,
        :city     => self.billing_city,
        :state    => state,
        :country  => 'US',
        :zip      => self.billing_zip
      }
    }
    options
  end
end
