class Category < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_tree :order => "name"
#  acts_as_breadcrumbs(:include_root)
  # acts_as_breadcrumbs(:attr => :url, :basename => :slug, :separator => "/")
  #   acts_as_breadcrumbs(:basename => :link, :separator => "&nbsp;&gt;&nbsp;")
  FINANCING_ID = 170

  i_am_paranoid
  
  has_many :project_types  #, :dependent => :destroy
  
  validates_presence_of :name
  #validates_uniqueness_of :name
  
  
#  def destroy
#    self.update_attribute(:deleted_at, Time.now)    
#  end
#  
#  def destroy!
#    self.update_attribute!(:deleted_at, Time.now)    
#  end
  
  
  def before_save
    self.permalink = self.name.downcase.gsub(/[^a-z0-9]+/i, '-')

    i = 2
    while Category.find(:first, :conditions => ["permalink = ? AND id != ?", self.permalink, self.id])
      self.permalink += i.to_s
      i += 1
    end    
  end
  
  
  def after_destroy
    self.project_types.each {|p| p.destroy }
    #self.reload
  end
  
  
  def self.find_root
    Category.find(:first, :conditions => ["parent_id IS NULL"])
  end
  
  
  def top
    c = self
    c = c.parent while c.parent.name != "root"
    c
  end

end
