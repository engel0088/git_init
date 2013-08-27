// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function mark_for_destroy(element) {
	$(element).next('.should_destroy').value = 1;
	$(element).up('.possible_response').hide();
}

// Show or hide element in the array according to the style of each element
function showhide(element_array) {
	element_array.each(function(element) {
		$(element).getStyle('display') == 'none' ? $(element).show() : $(element).hide();
	});
}