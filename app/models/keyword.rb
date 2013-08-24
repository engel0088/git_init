class Keyword < ActiveRecord::Base
  acts_as_tree :order => "name"
  
  
  def before_save
    
    #### Create a permalink
    if self.parent
      self.permalink = self.parent.permalink + '/'
    else
      self.permalink = ''
    end
        
    self.permalink += self.name.downcase.gsub(/[^a-z0-9]+/i, '-')
    
    i = 2
    while Category.find(:first, :conditions => ["permalink = ? AND id != ?", self.permalink, self.id])
      self.permalink += i.to_s
      i += 1
    end    
  end
  
  def self.find_roots
    Keyword.find(:all, :conditions => ["parent_id IS NULL"])
  end

end
