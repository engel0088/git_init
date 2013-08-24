# Rather than debugging acts_as_paranoid i implemented my own simpler version for our need
# although it is not as flexible.
module Paranoid
  
  module ClassMethods; end
    
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
 
    def i_am_paranoid
      class << self
        alias_method :original_find, :find
        alias_method :original_count, :count   
        alias_method :destroy!, :destroy
      end
      include InstanceMethods
    end
  end
  
  module InstanceMethods #:nodoc:
                
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods

      def find_with_deleted(*args)
        original_find(*args)
      end

      def find(*args)
        with_scope(:find => { :conditions => "#{table_name}.deleted_at IS NULL" }) do
          super(*args) 
        end
      end

      def count_with_deleted(*args)
        original_count(*args)
      end

      def count(*args)
        with_scope(:find => { :conditions => "#{table_name}.deleted_at IS NULL" }) do
          super(*args)
        end
      end
    
    end
    def destroy
      return false if callback(:before_destroy) == false
      result = self.update_attribute(:deleted_at, Time.now)
      callback(:after_destroy)
      return result
    end
    
    def deleted?
      self.deleted_at ? true : false
    end
    
  end  
end
