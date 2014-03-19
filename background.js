var interceptedContentTypes = ['text/xml', 'application/xml', 'application/rdf+xml', 'application/atom+xml', 'application/rss+xml'];

chrome.webRequest.onHeadersReceived.addListener(
	function(details) {
		if (~details.statusLine.indexOf('200 OK')) {
			_.each(details.responseHeaders, function(header) {
				if (header.name.toLowerCase() == 'content-type') {
					var headerValue = header.value.toLowerCase();
					var matchedType = _.find(interceptedContentTypes, function(t) {
						return ~headerValue.indexOf(t);
					});
					
					if (matchedType) {
						console.log("it works!");
						alert("it works!");
					}
				}
			});
		}
	}, 
	{
		'urls': ['http://*/*', 'https://*/*'],
		'types': ['main_frame']
	}, 
	['blocking', 'responseHeaders']);