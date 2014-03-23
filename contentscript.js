/**
 * Renders XML document
 * @include "underscore.js"
 */

//fallback to old Chrome API
var sendMessage = chrome.extension.sendMessage || chrome.extension.sendRequest;


function toXml(text) {
	var result = (new DOMParser()).parseFromString(text, 'text/xml');
	
	if (!result || !result.documentElement
			|| result.documentElement.nodeName == 'parsererror'
			|| result.getElementsByTagName('parsererror').length) {
				
				
		var error = result.getElementsByTagName('parsererror')[0];
		console.log(error);
		throw "<h2>Can’t parse XML document</h2> \n" + (error ? error.textContent : '');
	}
	
	return result;
}


function doTransform(data) {
	sendMessage({action: 'get-xsl', filePath: 'XMLPrettyPrint.xsl'},
		function(response) {
			var xsl_proc = new XSLTProcessor();
			xsl_proc.importStylesheet(toXml(response.fileText));
			
			xsl_proc.setParameter(null, 'mycss', chrome.extension.getURL('XMLPrettyPrint.css'));

			var result = xsl_proc.transformToDocument(data);
			document.replaceChild(document.adoptNode(result.documentElement), document.documentElement);
			
			xv_dom.setHTMLContext(result);
			
			var doctype = document.implementation.createDocumentType('html',
                                    '-//W3C//DTD XHTML 1.0 Transitional//EN',
                                    'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd');

			var xml_doc = document.implementation.createDocument(
                                    'http://www.w3.org/1999/xhtml', 'html', doctype);

			var replacement = null;
			if (data instanceof Document) {
				replacement = xml_doc.adoptNode(data.documentElement);
			} else {
				// assume 'data' is a node with HTML elements in it
				replacement = xml_doc.createDocumentFragment();
				_.each(data.childNodes, function(elem){
					replacement.appendChild(xml_doc.importNode(elem, true));
				});
			}
			xml_doc.replaceChild(replacement, xml_doc.documentElement);
			console.log("[contentscript] finished xml process!!");
		}
	);
}

document.addEventListener('readystatechange', function() {
	if (document.readyState == 'complete') {
		var el = document && document.getElementById('webkit-xml-viewer-source-xml');
		if (el) { // Chrome 12.x with native XML viewer
			console.log("[contentscript] it works!");
			
			el.parentNode.removeChild(el);
			doTransform(el);
		}
	}
});