class Setting < ActiveRecord::Base
  def self.get(name)
    s = Setting.find(:first, :conditions => ["name = ?", name.to_s.upcase])
    s ? s.value : nil
  end

end
