class OrderChange < ActiveRecord::Base
  OPERATION_ADD = "add"
  OPERATION_REMOVE = "remove"
  belongs_to :order
  has_many :order_change_items
  
  acts_as_state_machine :initial => :pending, :column => 'status'
  state :pending
  state :done, :enter => :activate_monopolies
  
  event :activate do
    transitions :from => :pending, :to => :done
  end
  
  def added_monopolies
    added = []
    self.order_change_items.each do |item|
      added << item.monopoly if item.operation == OPERATION_ADD
    end
    added
    #Monopoly.find(:all, :conditions => ["order_change_items.operation = ?"], :joins => "INNER JOIN order_change_items")
  end
  
  def removed_monopolies
    removed = []
    self.order_change_items.each do |item|
      removed << item.monopoly if item.operation == OPERATION_REMOVE
    end
    removed    
  end
  
  def apply_diff(new_monopolies)
    
    new_monopolies.each do |monopoly_id|
      
      monopoly = Monopoly.find(monopoly_id)
      unless self.order.monopolies.include?(monopoly)
        #activate << monopoly
        self.order_change_items.build(:operation => OrderChange::OPERATION_ADD, :monopoly_id => monopoly.id)
      end      
    end
    
    self.order.monopolies.each do |monopoly|
      
      unless new_monopolies.include?(monopoly)
        #deactivate << monopoly
        self.order_change_items.build(:operation => OrderChange::OPERATION_REMOVE, :monopoly_id => monopoly.id)
      end
    end
  end  
  
  def activate_monopolies
    transaction do
      checksum = 0
      self.order_change_items.each do |item|
        
        case item.operation
        when OPERATION_ADD
          item.monopoly.activate!(self.order.contractor, Date.today, self.order.end_date)
          self.order.monopolies << item.monopoly
          checksum += 1
        when OPERATION_REMOVE
          item.monopoly.deactivate!
          self.order.monopolies.delete(item.monopoly)
          checksum -= 1
        end
      end
      raise InconsistentChangeException.new if checksum != 0
      order.save!      
    end    
  end
  
  
  class InconsistentChangeException < Exception
  end
  
end
