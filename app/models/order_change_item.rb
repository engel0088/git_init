class OrderChangeItem < ActiveRecord::Base
  belongs_to :order_change
  belongs_to :monopoly
end
