module AnonymousQuestionnairesHelper
  def display_field(question, object)
    #sdebugger
    object += "[#{question.id}]"
    case question.question_type.id
      # Text field
      when 1
    		html = text_field_tag "#{object}", current_value(question)
    	# Text area
    	when 2
    		html = text_area_tag "#{object}", current_value(question), :rows => 10, :cols => 80
	
    	# Date field
    	when 3
    		html = calendar_date_select_tag "#{object}", current_value(question)
	
    	# Date and time field
    	when 4
    		html = calendar_date_select_tag "#{object}", current_value(question), :time => true
	
    	# Time field
    	when 5
    		html = time_select "#{object}", current_value(question)
	
    	# Scroll list field
    	when 6 
#s        debugger
        html = select_tag "#{object}", "<option>Please Select</option>" + options_from_collection_for_select(question.possible_responses, :response, :response, current_value(question))
	
    	# Radio buttons field
    	when 7
    		html = ""
    		question.possible_responses.each do |response|
    		  html += radio_button_tag "#{object}", response.response, (response.response == current_value(question))
    		  html += response.response+"<br/>"
    		end
	
    	# Multi-choices field (Check boxes)
    	when 8
    		html = ""
    		question.possible_responses.each do |response|
    		  html += check_box_tag "#{object}[]", response.response, ((current_value(question) || []).include?(response.response))
    		  html += response.response+"<br/>"
    		end
    end
    html
  end
  
  def current_value(question)
    if params[:lead] && params[:lead][:questionnaire]
      params[:lead][:questionnaire][question.id.to_s]
    end    
  end
end
