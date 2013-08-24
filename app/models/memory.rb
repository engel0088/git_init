class Memory < ActiveRecord::Base
  def self.remember(type, text)
    
    unless Memory.exists?(["tipe = ? AND text = ?", type, text])
      Memory.create(:tipe => type, :text => text)
    end
  end

end
