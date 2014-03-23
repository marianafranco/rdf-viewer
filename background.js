var xsl = null;
var interceptedContentTypes = ['text/xml', 'application/xml', 'application/rdf+xml'];

function loadXsl(url){
	var xhr = new XMLHttpRequest();
	xhr.open('GET', url, true);
	xhr.onreadystatechange = function(){
		if (xhr.readyState == 4) {	//request finished and response is ready
			xsl = xhr.responseText;
		}
	};
	xhr.send();
}

(chrome.extension.onMessage || chrome.extension.onRequest).addListener(function(request, sender, sendResponse) {
	switch (request.action) {
		case 'get-xsl':
			if (xsl === null)
				loadXsl(request.filePath);
				
			sendResponse({fileText: xsl});
			break;
	}
});	

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
						//alert("it works!");

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

loadXsl('XMLPrettyPrint.xsl');