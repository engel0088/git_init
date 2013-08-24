class Notification < ActiveRecord::Base
  def newsletter(recipients, from, subject, message)
    @recipients = recipients
    @from = from
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    body[:message] = message
  end
  
  def insurance_expiration(contractor)
    @recipients = contractor.email
    @from = Setting.get(:system_email_address)
    @subject = "Your Insurance is Expiring!"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:contractor] = contractor    
  end
  
  def new_lead(contractor, lead)
    @from = Setting.get(:system_email_address)
    @subject = "HIEx - You have a new Lead"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:lead] = lead
    if contractor
      @recipients = contractor.email
      body[:contractor] = contractor
    else
      @recipients = ""
    end
  end
  
  def contact_form(name, company, phone, email, comment)
    @recipients = User.find_by_login("admin").email
    @from = Setting.get(:system_email_address)
    @subject = "HIEx - CONTACT FORM"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:name] = name
    body[:company] = company
    body[:phone] = phone
    body[:email] = email
    body[:comment] = comment
  end
  
  def contractor_signup(name, company, zip_code, phone, mobile, email, category, where_found_us, referred_by)
    @recipients = User.find_by_login("admin").email
    @from = Setting.get(:system_email_address)
    @subject = "HIEx - Contractor Registration"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:name] = name
    body[:company] = company
    body[:zip_code] = zip_code
    body[:phone] = phone
    body[:mobile] = mobile
    body[:email] = email
    body[:category] = category
    body[:where_found_us] = where_found_us
    body[:referred_by] = referred_by
  end
  
  def debug(message)
    @recipients = "js@admiregroup.com"
    @from = Setting.get(:system_email_address)
    @subject = "HIEx - DEBUG"
    @sent_on = Time.now
    @content_type = "text/html"
    body[:message] = message      
  end
end
