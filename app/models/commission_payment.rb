class CommissionPayment < ActiveRecord::Base
  belongs_to :sales_person
  has_many :orders

  attr_accessor :method, :billing_name, :billing_address, :billing_city, :billing_state_id, :billing_zip
end
