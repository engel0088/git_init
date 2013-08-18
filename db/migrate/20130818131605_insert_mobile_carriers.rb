class InsertMobileCarriers < ActiveRecord::Migration
  def up
    add_column :mobile_carriers, :code, :string
    MobileCarrier.create(:name => "Alltel Wireless", :code => "alltel")
    MobileCarrier.create(:name => "Ameritech Cellular", :code => "ameritech")
    MobileCarrier.create(:name => "AT&T/Cingular", :code => "at&t")
    MobileCarrier.create(:name => "Bell South Mobility", :code => "bellsouthmobility")
    MobileCarrier.create(:name => "Blue Sky Frog", :code => "blueskyfrog")
    MobileCarrier.create(:name => "Boost Mobile", :code => "boost")
    MobileCarrier.create(:name => "Cellular South", :code => "cellularsouth")
    MobileCarrier.create(:name => "Kajeet", :code => "kajeet")
    MobileCarrier.create(:name => "metroPCS", :code => "metropcs")
    MobileCarrier.create(:name => "Power Tel", :code => "powertel")
    MobileCarrier.create(:name => "PSC wireless", :code => "pscwireless")
    MobileCarrier.create(:name => "Qwest", :code => "qwest")
    MobileCarrier.create(:name => "Southern Link", :code => "southernlink")
    MobileCarrier.create(:name => "Sprint Wireless", :code => "sprint")
    MobileCarrier.create(:name => "SunCom Wireless", :code => "suncom")
    MobileCarrier.create(:name => "T-Mobile US", :code => "t-mobile")
    MobileCarrier.create(:name => "Virgin Mobile", :code => "virgin")
    MobileCarrier.create(:name => "Verizon Wireless", :code => "verizon")
  end

  def down
  end
end
