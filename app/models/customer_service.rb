class CustomerService < ActiveRecord::Base
  def request(user, subject, message)
    @recipients = Setting.get(:system_email_address)
    @from = user.email
    headers "Reply-to" => user.email
    @subject = subject
    @sent_on = Time.now
    @content_type = "text/html"
    body[:user] = user
    body[:message] = message
  end
end
