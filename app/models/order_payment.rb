class OrderPayment < Payment
  belongs_to :order
  belongs_to :contractor

  #before_create Proc.new { self.contractor = self.order.contractor }
 attr_accessor :method, :billing_name, :credit_card_number, :credit_card_month_exp, :credit_card_year_exp, :credit_card_cvv, :billing_address, :billing_city, :billing_state_id, :billing_zip

  def contractor
    Contractor.find_with_deleted(self.order.contractor_id)
    #self.order.contractor
  end


  def before_create
    if self.credit_card?
      cc = self.create_cc
      #cc.valid?
      #raise cc.errors.inspect
      raise OrderPaymentException.new("Credit card not valid: " + cc.validate.to_s) unless cc.valid?    # => auto-detects the card type 
      
      amount_to_charge = Money.us_dollar(self.amount * 100)
      response = $payment_gateway.authorize(amount_to_charge, cc, self.options)
      raise OrderPaymentException.new("Authorization Failed: " + response.message.to_s) unless response.success?
            
      self.transaction_id = response.authorization
      #
        
    end
    self.order.commit 
  end

  def after_create
    if self.credit_card?
      amount_to_charge = Money.us_dollar(self.amount * 100)
      response = $payment_gateway.capture(amount_to_charge, self.transaction_id, self.options)
      
      #unless response.success?
              
      #end      
    end
  end

end
