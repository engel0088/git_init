# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


    c=Category.new
    c.name ="root"
    c.save



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
