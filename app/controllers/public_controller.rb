class PublicController < ApplicationController
  layout 'site'
  helper 'anonymous_questionnaires'
  #session :off
  
  # Landing page (home page)
  def index
    @lead = Lead.new(params[:lead])
    
    if request.post?
      if @lead.save
        #store_lead(@lead)
        # conv parameters is not used by the app, but only for google analytics purposes.        
        redirect_to :action => 'category', :category_id => @lead.category_id, :lead_guid => @lead.guid, :conv => 1 

        return
      end
    end
    @categories = Category.find_root.children
    
  end
    
  # Choose a project type (STEP 1)
  def category
#    if params[:lead]
#      #store_customer Lead.new(params[:lead])     
#      @lead = Lead.new(params[:lead]) 
#      if @lead.save
#        
#      else
#        
#      end
#      #lead.save(false)
#    end
    
    if params[:category_id]
      @category = Category.find(params[:category_id]) 
    else
      @category = Category.find_by_permalink(params[:permalink])
    end
    # If some lead info is defined store it.
    
    redirect_to :action => 'index' unless @category # if could not find a category (modified url)
    
  rescue ActiveRecord::RecordNotFound    
    flash[:notice] = "Please select a category"
    redirect_to :action => 'index'
  end
    
    
  
  # Describe your project form (STEP 2)
  def describe   
    
    if params[:lead]
      @lead = Lead.new(params[:lead])
    elsif (params[:lead_guid] && @lead = Lead.find_by_guid(params[:lead_guid]))
      
    else
      @lead = Lead.new
    end
    @lead.call_me = "24 hours" if @lead.call_me.blank?
    
    
    # = params[:project_type_id]
       
    if params[:project_type_id]
      @project_type = ProjectType.find(params[:project_type_id]) 
    else
      @project_type = ProjectType.find_by_permalink(params[:permalink])
    end
    raise ActiveRecord::RecordNotFound unless @project_type
    
    @lead.project_type_id = @project_type.id
    @category = @project_type.category.top
    # what if it doesn't exist
    @questions = @project_type.questionnaire.questions
    @questionnaire = @project_type.questionnaire
    @anonymous_questionnaire = AnonymousQuestionnaire.new
  rescue ActiveRecord::RecordNotFound
    @categories = Category.find_root.children
    
    @category = Category.find(params[:category_id]) if params[:category_id]    
    @project_types = @category.project_types if @category
    #raise @project_types.inspect
    flash[:notice] = "Please select a category and a project type."
    render :action => 'index'
  end
  
  # Submit the lead
  def submit
    #if request.get?
    #  render :nothing => true, :status => 404
    #  return
    #end
    
    
    if params[:lead] && params[:lead][:guid] && @lead = Lead.find_by_guid(params[:lead][:guid])  
      @project_type = ProjectType.find(params[:lead][:project_type_id])
      
      
      if @lead.update_attributes(params[:lead])
        
        # You have these calls in before_create, but well also want them here.
        @lead.assign_contractor
        @lead.assign_financer
        @lead.save
        @lead.send_notifications # Resend the notifications

        # Redirect client to result page for the recommended contractor.
        @contractor = @lead.contractor         
        @financer = @lead.financer
        redirect_to :action => "results", :contractor_id => @contractor, :project_type => @project_type, :financer_id => @financer
      else
        @questions = @project_type.questionnaire.questions
        @questionnaire = @project_type.questionnaire
        @anonymous_questionnaire = AnonymousQuestionnaire.new
        render :action => 'describe'        
      end      
    else
      @lead = Lead.new(params[:lead])
      @project_type = @lead.project_type

      if @lead.save
        @contractor = @lead.contractor         
        @financer = @lead.financer
        # Redirect client to result page for the recommended contractor.
        redirect_to :action => "results", :contractor_id => @contractor, :project_type => @project_type, :financer_id => @financer
      else
        @questions = @project_type.questionnaire.questions
        @questionnaire = @project_type.questionnaire
        @anonymous_questionnaire = AnonymousQuestionnaire.new
        render :action => 'describe'
      end
    end
  end
  
  def results
    @project_type = ProjectType.find(params[:project_type]) if params[:project_type]
    @contractor = Contractor.find(params[:contractor_id])
    @financer = Contractor.find(params[:financer_id]) if params[:financer_id]
  rescue ActiveRecord::RecordNotFound
    
  end
  
  def contact
    if request.post?
      Notification.deliver_contact_form(params[:name], params[:company], params[:phone], params[:email], params[:comment])
    end
    render :layout => 'site_cms'    
  end
  
  def signup
    @categories = Category.find_root.children
    flash[:error] = nil

    if request.post?
      if params[:name].blank?
        flash[:error] = "<ul>" if flash[:error].blank?
        flash[:error] += "<li><b>Name</b> can't be blank!</li>"
      end

      if params[:zip_code].blank?
        flash[:error] = "<ul>" if flash[:error].blank?
        flash[:error] += "<li><b>Zip code</b> can't be blank!</li>"
      end
      
      phone = nil      
      if params[:phone].blank?
        flash[:error] = "<ul>" if flash[:error].blank?
        flash[:error] += "<li><b>Phone</b> can't be blank!</li>"
      else
        phone = params[:phone].to_s.gsub(/[^\d]/, '')
        if phone.size < 10
          flash[:error] = "<li><b>#{params[:phone]}</b> is not a valid US phone number (it must contain at least 10 digits)</li>"
        elsif phone.size > 15
          flash[:error] = "<li><b>#{params[:phone]}</b> is too long (maximum is 15 characters)</li>"
        end    
      end
      
      if params[:email].blank?
        flash[:error] = "<ul>" if flash[:error].blank?
        flash[:error] += "<li><b>Email</b> can't be blank!</li>"
      end
      
      if params[:category].blank?
        flash[:error] = "<ul>" if flash[:error].blank?
        flash[:error] += "<li>You must select a <b>category</b>!</li>"
      end
      
      unless flash[:error].blank?
        flash[:error] += "</ul>"    
      else
        # No errors do the notification
        Notification.deliver_contractor_signup(params[:name], 
          params[:company], params[:zip_code], phone, params[:mobile], params[:email], params[:category], 
          params[:where_found_us], params[:referred_by])
        setup_js_tracking_code
      end
    end
    
    render :layout => 'site_cms'
  end

  def setup_js_tracking_code
    @zip_code = params[:zip_code]
    zip_code = ZipCode.find_by_code(@zip_code)
    @state = (zip_code.nil? ? "[invalid state (zip=#{@zip_code})]" : zip_code.state_code)
  end
  
  def resources
    
    @page = Comatose::Page.find_by_path('resource-center')
    @articles = (@page ? @page.children : [])
    @articles = @articles.sort_by {|a| a.created_on }.reverse
    #unless read_fragment("resources_news")
    when_fragment_expired 'resources_news', 1.hour.from_now do 
      feed_url = Setting.get("NEWS_FEED_URL")
      begin      
        open(feed_url) do |http|
          response = http.read
          @feed_articles = RSS::Parser.parse(response, false).items
        end
      rescue Exception => e
        flash[:error] = "News are not available right now!"
        @feed_articles = []
      end
    end
    
    #render_text output
    render :layout => 'site_cms'
  end
  
  def browse
    @page_title = "Find Local Contractors Now!"
    @keywords = Keyword.find_roots
    render :layout => 'site_cms'
  end
  
  def browse_form
    @lead = Lead.new(params[:lead])
    @keyword = Keyword.find_by_permalink(params[:permalink].join('/'))
    @categories = Category.find_root.children
    
    if @keyword    
      @page_title = "Find #{@keyword.name.titleize} Now!"
      render :layout => 'site_cms'
    else
      redirect_back_or_default :action => "browse"
    end
  end
  
#  def project_types    
#    
#    begin
#      @project_types = Category.find(params[:category_id]).project_types
#    rescue ActiveRecord::RecordNotFound
#      @project_types = []
#    end
#    
#    respond_to do |format|
#      format.js { render :partial => 'project_types.html.erb'}      
#    end    
#  end
#  
  
  
  protected
  
#  def store_lead(lead)
#    cookies[:lead_guid] = {:value => lead.guid, :expires => 1200.seconds.from_now}
##    cookies[:customer_info] = {:value => "#{lead.name.to_s.gsub('|', '')}|#{lead.phone.to_s.gsub('|', '')}|#{lead.email.to_s.gsub('|', '')}|#{lead.postal_code.to_s.gsub('|', '')}", :expires => 300.seconds.from_now}
#  end
#  
#  def get_lead
#    
#    return nil unless cookies[:lead_guid]
##    info = cookies[:customer_info].split('|')
##    Lead.new(:name => info[0], :phone => info[1], :email => info[2], :postal_code => info[3])
#    begin
#      return Lead.find_by_guid(cookies[:lead_guid])
#    rescue ActiveRecord::RecordNotFound
#      return nil
#    end
#  end
end
