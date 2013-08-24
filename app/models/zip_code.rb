class ZipCode < ActiveRecord::Base
  acts_as_mappable
  
  validates_uniqueness_of :code
  validates_presence_of :code, :city, :state_code
  validates_numericality_of :code, :less_than_or_equal_to => 99999
  validates_length_of :state_code, :is => 2
  validates_numericality_of :lat, :allow_blank => true
  validates_numericality_of :lng, :allow_blank => true
  
  #before_destroy {|o| return false if o.monopolies.size > 0 }
  
  
  has_many :monopolies, :dependent => :protect
  # This is neat little function that does all the zip code searching from a query string. Accepted inputs are:
  # 12345 (zip code)
  # 12345, 12346, 12347 (zip code list)
  # NY (state code)
  # New York (city)
  # New York, NY (city, state)
  # 54 Stone St, New york (address, city)
  # 54 Stone St, New york, NY (address, city, state)
  # and others .. by default it searches Yahoo! see http://developer.yahoo.com/maps/rest/V1/geocode.html
  def self.search(query, page = 1, within = 0, order = "code")
    query = query.to_s.strip
    zips = []
    not_found = nil
    page_size = 50
    current_page = page
    #debugger
    if within == 0    

      # Check for zip codes
      if query =~ /^(\d{3,5})(,\s*\d{3,5})*$/ # Match zip codes
        zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :conditions => ["code IN (?)", query.split(",").collect {|z| z.strip.to_i}], :order => order, :include => :monopolies)
      elsif query =~ /^(\d{3,5})\-(\d{3,5})$/ # Match zip codes range
        zstart, zend = query.split('-').collect {|z| z.strip}
        zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :conditions => ["code >= ? AND code <= ?", zstart, zend])
      elsif query =~ /^[A-Za-z]{2,2}$/ # State code
        zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :conditions => ["state_code = ?", query.upcase], :order => order, :include => :monopolies)
      #end
      else
        begin     
          location = MultiGeocoder.geocode(query)
        rescue GeoKit::Geocoders::GeocodeError => e
          raise SearchException.new("We could not find the specified origin. (#{e.message})")
        end  
 
        if location.success
          if location.zip
            zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :conditions => ["code = ?", location.zip], :order => order, :include => :monopolies)
          elsif location.city
            condition = ["city LIKE ?", location.city.upcase]
            # JSB20080303: Removed because when you have city names existing in multiple states.
            #if location.state 
            #  condition[0] += " AND state_code = ?"
            #  condition << location.state.upcase
            #end
            zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :conditions => condition, :order => order, :include => :monopolies)
          elsif location.state
            zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :conditions => ["state_code = ?", location.state], :order => order, :include => :monopolies)
          else
            raise SearchException.new("No zip codes could be found for this location!")
          end
        else
          raise SearchException.new("The location could not be found!")
        end
      end
    # If within is specified we call Y! straigh up
    else
      begin
        zips = ZipCode.find(:all, :page => {:size => page_size, :current => current_page}, :origin => query, :within => within, :include => :monopolies, :order => order)
      rescue GeoKit::Geocoders::GeocodeError 
        raise SearchException.new("We could not find the specified origin.")
      end  
    end
    zips
  end

  def available?(category)
    available = true
    monopolies.each {|m| available = m.available? if category.id == m.category_id && m.contractor_id }
    available
  end

  class SearchException < Exception
  end


end
