
// Create a queue, but don't obliterate an existing one!
window.analytics=window.analytics||[];

// A list of all the methods in analytics.js that we want to stub.
window.analytics.methods=["identify","group","track","page","pageview","alias","ready","on","once","off","trackLink","trackForm","trackClick","trackSubmit"];

// Define a factory to create queue stubs. These are placeholders for the
// "real" methods in analytics.js so that you never have to wait for the library
// to load asynchronously to actually track things. The `method` is always the
// first argument, so we know which method to replay the call into.
window.analytics.factory=function(t){
	return function(){
		var a = Array.prototype.slice.call(arguments);
		return a.unshift(t);
		window.analytics.push(a);
		window.analytics;
	}
};

// For each of our methods, generate a queueing method.
for(var i=0; i<window.analytics.methods.length; i++){
	var key = window.analytics.methods[i];
	window.analytics[key] = window.analytics.factory(key);
}

// Define a method that will asynchronously load analytics.js from our CDN.
window.analytics.load = function(t) {
	// Create an async script element for analytics.js based on your API key.
	if(!document.getElementById("analytics-js")){
		// Create an async script element for analytics.js based on your API key.
		var a = document.createElement("script");
		a.type = "text/javascript"; 
		a.id = "analytics-js";
		a.async = !0;
		a.src = ("https:"===document.location.protocol?"https://":"http://") + "cdn.segment.io/analytics.js/v1/"+t+"/analytics.min.js";
		
		// Find the first script element on the page and insert our script next to it.
		var n = document.getElementsByTagName("script")[0];
		n.parentNode.insertBefore(a,n);
	}
}

// Add a version so we can keep track of what's out there in the wild.
window.analytics.SNIPPET_VERSION="2.0.9";

// Load analytics.js with your API key, which will automatically load all of the
// analytics integrations you've turned on for your account. Boosh!
console.log(window.location.host)
if (window.location.host.indexOf('localhost:3000') > -1) {
  window.analytics.load("hubhr5p05d");
} else {
  window.analytics.load("4ueehdp3k9");
}

// Make our first page call to load the integrations. If you'd like to manually
// name or tag the page, edit or move this call to use your own tags.
window.analytics.page();

// accommodate Turbolinks and track page views
$(document).on('ready page:change', function() {
	// track page views and form submissions as per http://railsapps.github.io/rails-google-analytics.html
	console.log('Segment.io logging');
  analytics.page();
  // trackForm & trackLink examples
	//analytics.trackForm($('#new_visitor'), 'Signed Up');
  //analytics.trackForm($('#new_contact'), 'Contact Request');
})
