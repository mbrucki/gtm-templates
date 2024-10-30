___INFO___

{
  "type": "CLIENT",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Cross-linker Client",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "This client facilitates cross-domain-tracking for custom user_id and UTM parameters.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_SERVER___

const claimRequest = require('claimRequest');
const getRequestPath = require('getRequestPath');
const getRequestQueryParameters = require('getRequestQueryParameters');
const setResponseStatus = require('setResponseStatus');
const setResponseBody = require('setResponseBody');
const setResponseHeader = require('setResponseHeader');
const returnResponse = require('returnResponse');
const logToConsole = require('logToConsole'); 
const JSON = require('JSON');

// Check the request path
const requestPath = getRequestPath();
logToConsole("Request path: " + requestPath);

// Only claim the request if the path matches /crosslinker
if (requestPath === '/crosslinker') {
  logToConsole("Path matched: /crosslinker, claiming request.");
  claimRequest();  // Claim the request

  // Extract the query parameters from the request
  const queryParams = getRequestQueryParameters();
  const allowedDomains = queryParams.allowedDomains ? queryParams.allowedDomains.split(',') : [];
  const cookieName = queryParams.cookieName || '';
  const cookieValue = queryParams.cookieValue || '';

  // Initialize an empty array for UTM parameters
  const utmParams = [];

  // Dynamically collect UTM parameters from the query string
  for (var key in queryParams) {
    if (key.indexOf('gtm_utm_') === 0) {  // Check if the key starts with 'gtm_utm_'
      utmParams.push(key);  // Add UTM parameter names (e.g., gtm_utm_campaign, gtm_utm_source)
    }
  }

  // Check if all required parameters are available
  if (!cookieName || !cookieValue || allowedDomains.length === 0) {
    logToConsole("Missing required parameters.");
    setResponseStatus(400);  // Bad Request
    setResponseBody('Missing required parameters.');
    returnResponse();
    return;
  }

  // Function expression to generate the JavaScript for link modification
  const generateScript = function(allowedDomains, cookieName, cookieValue, utmParams) {
    return "(function() {" +
      "var cookieName = '" + cookieName + "';" +
      "var cookieValue = '" + cookieValue + "';" +
      "var allowedDomains = " + JSON.stringify(allowedDomains) + ";" +
      "var utmParams = " + JSON.stringify(utmParams) + ";" +  // Pass UTM parameters

      // Function to normalize domain (remove 'www.' and protocol)
      "function normalizeDomain(domain) {" +
        "return domain.replace(/^https?:\\/\\//, '').replace(/^www\\./, '').toLowerCase();" +
      "}" +

      // Function to add a parameter to the URL manually
      "function addParamToUrl(url, paramName, paramValue) {" +
        "var urlParts = url.split('?');" +
        "var baseUrl = urlParts[0];" +
        "var queryString = urlParts[1] || '';" +
        "var params = new URLSearchParams(queryString);" +
        "params.set(paramName, paramValue);" +
        "return baseUrl + '?' + params.toString();" +
      "}" +

      // Function to modify links on the page
      "function modifyLinks() {" +
        "var links = document.querySelectorAll('a[href]');" +
        "Array.prototype.forEach.call(links, function(link) {" +
          "var urlObj = document.createElement('a');" +
          "urlObj.href = link.href;" +

          // Normalize the link domain
          "var normalizedLinkDomain = normalizeDomain(urlObj.hostname);" +

          // Normalize allowed domains for comparison
          "var normalizedAllowedDomains = allowedDomains.map(function(domain) { return normalizeDomain(domain); });" +

          // Check if the link points to one of the allowed domains
          "if (normalizedAllowedDomains.includes(normalizedLinkDomain)) {" +
            // Add the cookie parameter to the URL
            "link.href = addParamToUrl(link.href, cookieName, cookieValue);" +

            // Add UTM parameters to the URL
            "utmParams.forEach(function(param) {" +
              "var paramValue = localStorage.getItem(param);" +  // Retrieve UTM value from localStorage
              "if (paramValue) {" +
                "link.href = addParamToUrl(link.href, param, paramValue);" +  // Append UTM param
              "}" +
            "});" +
          "}" +
        "});" +
      "}" +

      "modifyLinks();" +  // Execute link modification on page load
    "})();";
  };

  // Set the headers for returning JavaScript
  setResponseHeader('Content-Type', 'application/javascript');

  // Generate and set the response body (the script)
  setResponseBody(generateScript(allowedDomains, cookieName, cookieValue, utmParams));  // Pass UTM parameters

  // Set response status and send the response
  setResponseStatus(200);  // OK
  returnResponse();

} else {
  logToConsole("Invalid path, request not claimed.");
  setResponseStatus(404);  // Not Found if the path doesn't match
  setResponseBody('Not Found');
  returnResponse();
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "return_response",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 30/10/2024, 12:21:26


