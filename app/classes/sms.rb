class SMS
  
  def self.send_text(recipient, message)
    return true if CLICKATELL_CONFIG == {} # Case where no config (TEST AND DEV)
    
    return false if recipient.blank?
    
    recipient = "1#{recipient}" unless recipient[0,1].to_i == 1
    #puts recipient
    
    #Notification.deliver_debug("recipient: #{recipient}, #{message};")
    recipient = recipient.gsub(/[^\d]/, '')
    
    
    # Encode Message
    message = message.gsub('&', 'and') if message
    
    
    sms = SMS.new(CLICKATELL_CONFIG)
    SMS_LOGGER.info "#{Time.now} - Send SMS to #{recipient}: #{message}"
    sms.create(recipient, message)
    #raise "SMS sent to #{self.contractor.mobile}, #{message}, msgid: #{msgid}"
    
    return true
  rescue Clickatell::API::Error => e
    #logger.error("\nCould Not send SMS to #{recipient}: #{e.code} - #{e.message}\n")
    Notification.deliver_debug("\nCould Not send SMS to #{recipient}: #{e.code} - #{e.message}\n")
    SMS_LOGGER.info "SMS FAILED to be sent to #{recipient}: #{e.code} - #{e.message}"

    return false  
  end
  
  
  def initialize(config)
    @config = config
  end

  def create(recipient, message_text)
    api.send_message(recipient, message_text)
  end

  private
    def api
      @api ||= Clickatell::API.authenticate(
        @config["api_key"],
        @config["username"],
        @config["password"]
      )
    end
end
