class InsertMobileCarriers < ActiveRecord::Migration
  def up
    add_column :mobile_carriers, :code, :string
=begin
    [{:name => "Alltel Wireless", :code => "alltel"},
    {:name => "Ameritech Cellular", :code => "ameritech"},
    {:name => "AT&T/Cingular", :code => "at&t"},
    {:name => "Bell South Mobility", :code => "bellsouthmobility"},
    {:name => "Blue Sky Frog", :code => "blueskyfrog"},
    {:name => "Boost Mobile", :code => "boost"},
    {:name => "Cellular South", :code => "cellularsouth"},
    {:name => "Kajeet", :code => "kajeet"},
    {:name => "metroPCS", :code => "metropcs"},
    {:name => "Power Tel", :code => "powertel"},
    {:name => "PSC wireless", :code => "pscwireless"},
    {:name => "Qwest", :code => "qwest"},
    {:name => "Southern Link", :code => "southernlink"},
    {:name => "Sprint Wireless", :code => "sprint"},
    {:name => "SunCom Wireless", :code => "suncom"},
    {:name => "T-Mobile US", :code => "t-mobile"},
    {:name => "Virgin Mobile", :code => "virgin"},
    {:name => "Verizon Wireless", :code => "verizon"}].each do |mobile|
      m=MobileCarrier.new
      m.name = mobile[:name]
      m.code = mobile[:code]
      m.save
    end
=end
  end

  def down
  end
end
