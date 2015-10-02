// UAT Issue 27 counter not working properly.
// Modified by Yamini on 4th July 2014.


$().ready(function(){
	var max = 100;
	
	$("#order_cancel_remark").each(function(index){
		
		$(this).maxlength({ 
			
		    max: 100,
		    truncate: true, // True to disallow further input, false to highlight only 
		    showFeedback: true, // True to always show user feedback, 'active' for hover/focus only 
		    feedbackTarget: null, // jQuery selector or function for element to fill with feedback 
		    feedbackText: '{c}/{m}', 
		        // Display text for feedback message, use {r} for remaining characters, 
		        // {c} for characters entered, {m} for maximum 
		    overflowText: '{o} characters too many ({m} maximum)', 
		        // Display text when past maximum, use substitutions above 
		        // and {o} for characters past maximum 
		    onFull: null // Callback when full or overflowing, 
		        // receives one parameter: true if overflowing, false if not 
	});
	
	});
});
