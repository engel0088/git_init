class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Welcome to Home Improvement Expo'
  
    @body[:url]  = $HOST + "/login"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
  end
  
  def reset_notification(user)
    debugger
    setup_email(user)
    @subject    += 'Reset your password'
    @body[:url]  = "#{$HOST}/reset/#{user.reset_code}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = Setting.get(:system_email_address)
      @subject     = "[Home Improvement Expo] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
