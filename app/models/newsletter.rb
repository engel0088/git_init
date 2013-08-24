class Newsletter < ActiveRecord::Base
  include Validatable
  include ConditionsHelper
  
  attr_accessor :recipient_leads, :recipient_contractors, :recipient_sales_people,
    :recipient_category_id, :recipient_cc, :from, :subject, :message, :delivered, :failed,
    :from_date, :to_date
  
  #useless since there is no validation so far (comment from Martin)
  validates_presence_of :from, :subject, :message
  
  def initialize(params = {})
    params.each {|k,v| self.send(:"#{k}=", v) if self.respond_to?(:"#{k}=")}
  end
  
  def deliver
    if valid?
      @delivered = []
      @failed = []
      Memory.remember("newsletter_from", self.from)
      build_recipients_list.each do |r|
        begin
          Notification.deliver_newsletter("#{r[:email]}", self.from, self.subject, self.message)  
          @delivered << r
        rescue Net::SMTPFatalError => e
          r[:error] = e.message
          @failed << r
        rescue Net::SMTPSyntaxError => e
          r[:error] = e.message
          @failed << r
        end
      end
      true
    else
      false
    end
  end
  


  def build_recipients_list
    #raise self.inspect
    recipients = []
    if self.recipient_leads == "1"
      condition = []
      condition = merge_conditions(condition, ["leads.created_at BETWEEN ? and ?", Date.parse(self.from_date).strftime("%Y-%m-%d 00:00:00"), Date.parse(self.to_date).strftime("%Y-%m-%d 23:59:59")]) if self.from_date && self.to_date
      condition = merge_conditions(condition, ["leads.category_id = ?", self.recipient_category_id]) unless self.recipient_category_id.blank?
#      if self.recipient_category_id.blank?
#        leads = Lead.find(:all, :conditions => ["leads.created_at BETWEEN ? and ?", date_parse_strftime(self.from_date, "%Y-%m-%d 00:00:00"), date_parse_strftime(self.to_date, "%Y-%m-%d 23:59:59")])
#      else
#        leads = Lead.find(:all, :conditions => ["leads.category_id = ? AND leads.created_at BETWEEN ? and ?", self.recipient_category_id, date_parse_strftime(self.from_date, "%Y-%m-%d 00:00:00"), date_parse_strftime(self.to_date, "%Y-%m-%d 23:59:59")])
#      end
      leads = Lead.find(:all, :conditions => condition)

      recipients += leads.collect {|lead| {:email => lead.email, :name => lead.name}}
    end
    if self.recipient_contractors == "1"
      recipients += Contractor.find(:all).collect {|contractor| {:email => contractor.email, :name => contractor.name}}
    end
    if self.recipient_sales_people == "1"
      recipients += SalesPerson.find(:all).collect {|sp| {:email => sp.email, :name => sp.name}}
    end
    unless self.recipient_cc.blank?
      recipients += self.recipient_cc.split(',').collect {|e| {:email => e.strip}}
    end
    recipients
  end
  
# private
#   def date_parse_strftime(date, fmt)     
#     date ? Date.parse(date).strftime(fmt) : date
#   end
  
end
