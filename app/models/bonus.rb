class Bonus < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :sales_person
  belongs_to :payment
  validates_numericality_of :amount, :greater_than => 0
  validates_presence_of :sales_person_id

end
