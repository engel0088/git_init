class Monopoly < ActiveRecord::Base
  PRICE = 300 # in dollars

  belongs_to :zip_code
  belongs_to :category
  belongs_to :contractor # The owner of that monopoly.
  has_many :versions, :class_name => "MonopolyHistory"
  after_save :save_as_version

  def activate!(contractor, start, expiration)
    raise Monopoly::MonopolyAlreadyTaken.new if Monopoly.exists?(["id = ? AND expiration >= ? AND contractor_id IS NOT NULL", self.id, start])
    self.contractor_id = contractor.id
    self.expiration = expiration
    self.save
  end
  
  def active?
    self.contractor_id != nil
  end

  def deactivate!
    self.contractor_id = nil
    self.expiration = nil
    self.save
  end

  class MonopolyAlreadyTaken < Exception
  end

  def expires_soon?
    self.expiration && (self.expiration - Date.today <= 60)
  end


  def available?(from = Date.today)
    from ||= Date.today
    self.contractor == nil || self.expiration == nil || self.expiration < from
  end
  
  def self.match_contractor(lead)
    match = match_exact(lead.postal_code, lead.category, lead.created_at)
    unless match
      zip = ZipCode.find_by_code(lead.postal_code)
      closest = match_closest(lead.postal_code, lead.category, lead.created_at, zip.state_code)
      if closest #&& zip.state_code == closest.state.code
        match = closest
      else
        match = Contractor.find(Contractor::HOME_IMPROVEMENT_EXPO_ID) if Contractor.exists?(Contractor::HOME_IMPROVEMENT_EXPO_ID)      
      end
    end
    match
  end
  
  def self.match_financer(lead)
    match_exact(lead.postal_code, Category.find(Category::FINANCING_ID), lead.created_at) || match_closest(lead.postal_code, Category.find(Category::FINANCING_ID), lead.created_at)
  end
  
  
  def self.create_once(*params)
    transaction do
      if monopoly = Monopoly.find(:first, :conditions => ["zip_code_id = ? AND category_id = ?", params[0][:zip_code_id], params[0][:category_id]])
        return monopoly
      else
        return Monopoly.create(:zip_code_id => params[0][:zip_code_id], :category_id => params[0][:category_id])
      end
    end
  end
  
private


  def save_as_version
    MonopolyVersion.create(:zip_code_id => self.zip_code_id, 
      :contractor_id => self.contractor_id, 
      :category_id => self.category_id, 
      :expiration => self.expiration, 
      :monopoly_id => self.id)
  end


  def self.match_exact(postal_code, category, created_at)
    # Try an exact match
    monopolies = Monopoly.find(:all, :conditions => ["monopolies.contractor_id IS NOT NULL AND monopolies.category_id = ? AND zip_codes.code = ? AND monopolies.expiration >= ? AND contractors.status = 'active' ", category.id, postal_code.to_s.strip, created_at], :joins => "INNER JOIN contractors ON contractors.id = monopolies.contractor_id INNER JOIN zip_codes ON zip_codes.id = monopolies.zip_code_id")

    Notification.deliver_debug("CONFLICT FOR #{postal_code} / #{category} / #{created_at}") if monopolies.size > 1

    return monopolies.first.contractor if monopolies.first
  end
  
  
  def self.match_closest(postal_code, category, created_at, state_code = nil)
    # Find the nearest if there is no exact match
    zip = ZipCode.find_by_code(postal_code)
    
    condition = ["monopolies.contractor_id IS NOT NULL AND monopolies.category_id = ? AND monopolies.expiration >= ? AND contractors.status = 'active' ", category.id, created_at]
    if state_code
      condition[0] += " AND zip_codes.state_code = ?"
      condition << state_code      
    end
    closest_zip = ZipCode.find(:first, :select => "zip_codes.*, monopolies.id AS monopoly_id", :origin => zip, :joins => "INNER JOIN monopolies ON monopolies.zip_code_id = zip_codes.id INNER JOIN contractors ON contractors.id = monopolies.contractor_id", :conditions => condition, :order => "distance")
    
    return Monopoly.find(closest_zip.monopoly_id).contractor if closest_zip
    return nil    
  end
  
end
