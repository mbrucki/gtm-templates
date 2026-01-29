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
  return "(function() {"
    + "var cookieName = '" + cookieName + "';"
    + "var cookieValue = '" + cookieValue + "';"
    + "var allowedDomains = " + JSON.stringify(allowedDomains) + ";"
    + "var utmParams = " + JSON.stringify(utmParams) + ";"

    // Normalize domain without regex
    + "function normalizeDomain(domain) {"
      + "domain = String(domain || '').toLowerCase();"
      + "if (domain.indexOf('http://') === 0) domain = domain.substring(7);"
      + "if (domain.indexOf('https://') === 0) domain = domain.substring(8);"
      + "if (domain.indexOf('www.') === 0) domain = domain.substring(4);"
      + "return domain;"
    + "}"

    // Allow exact or subdomain match
    + "function isAllowedHost(host) {"
      + "var h = normalizeDomain(host);"
      + "for (var i = 0; i < allowedDomains.length; i++) {"
        + "var a = normalizeDomain(allowedDomains[i]);"
        + "if (!a) continue;"
        + "if (h === a) return true;"
        + "if (h.length > a.length && h.lastIndexOf('.' + a) === h.length - (a.length + 1)) return true;"
      + "}"
      + "return false;"
    + "}"

    // Add param and preserve hash
    + "function addParamToUrl(url, paramName, paramValue) {"
      + "try {"
        + "var hashIndex = url.indexOf('#');"
        + "var hash = '';"
        + "if (hashIndex >= 0) { hash = url.substring(hashIndex); url = url.substring(0, hashIndex); }"
        + "var qIndex = url.indexOf('?');"
        + "var baseUrl = qIndex >= 0 ? url.substring(0, qIndex) : url;"
        + "var queryString = qIndex >= 0 ? url.substring(qIndex + 1) : '';"
        + "var params = new URLSearchParams(queryString);"
        + "params.set(paramName, paramValue);"
        + "var qs = params.toString();"
        + "return baseUrl + (qs ? ('?' + qs) : '') + hash;"
      + "} catch (e) {"
        + "return url;"
      + "}"
    + "}"

    + "function decorateUrl(url) {"
      + "try {"
        + "var a = document.createElement('a');"
        + "a.href = url;"
        + "if (!isAllowedHost(a.hostname)) return null;"
        + "var out = url;"
        // cookie
        + "out = addParamToUrl(out, cookieName, cookieValue);"
        // UTMs from localStorage
        + "for (var i = 0; i < utmParams.length; i++) {"
          + "var p = utmParams[i];"
          + "var v = null;"
          + "try { v = localStorage.getItem(p); } catch (e) {}"
          + "if (v) out = addParamToUrl(out, p, v);"
        + "}"
        + "return out;"
      + "} catch (e) {"
        + "return null;"
      + "}"
    + "}"

    // Rewrite anchors present now
    + "function modifyLinks() {"
      + "var links = document.querySelectorAll('a[href]');"
      + "for (var i = 0; i < links.length; i++) {"
        + "var link = links[i];"
        + "var decorated = decorateUrl(link.href);"
        + "if (decorated) link.href = decorated;"
      + "}"
    + "}"

    // Capture-phase click interception (fixes <button onclick=window.location='...'>)
    + "function extractTargetUrl(el) {"
      + "if (!el) return null;"
      + "if (el.tagName === 'A' && el.href) return el.href;"
      + "if (el.tagName === 'BUTTON') {"
        + "var oc = el.getAttribute('onclick') || '';"
        // simple parser for patterns like: window.location='https://...';
        + "var key = 'location';"
        + "var idx = oc.toLowerCase().indexOf(key);"
        + "if (idx >= 0) {"
          + "var q1 = oc.indexOf(\"'\");"
          + "var q2 = oc.indexOf('\"');"
          + "var q = -1;"
          + "if (q1 >= 0 && q2 >= 0) q = Math.min(q1, q2);"
          + "else q = (q1 >= 0 ? q1 : q2);"
          + "if (q >= 0) {"
            + "var quoteChar = oc.charAt(q);"
            + "var end = oc.indexOf(quoteChar, q + 1);"
            + "if (end > q) return oc.substring(q + 1, end);"
          + "}"
        + "}"
      + "}"
      + "return null;"
    + "}"

    + "document.addEventListener('click', function(e) {"
      + "var el = e.target;"
      + "while (el && el !== document.documentElement) {"
        + "if (el.tagName === 'A' || el.tagName === 'BUTTON') break;"
        + "el = el.parentElement;"
      + "}"
      + "var url = extractTargetUrl(el);"
      + "if (!url) return;"
      + "var decorated = decorateUrl(url);"
      + "if (!decorated) return;"
      + "e.preventDefault();"
      + "e.stopImmediatePropagation();"
      + "window.location.assign(decorated);"
    + "}, true);"

    // Optional: keep rewriting anchors that appear later (menus, SPA)
    + "if (window.MutationObserver) {"
      + "var mo = new MutationObserver(function() { modifyLinks(); });"
      + "mo.observe(document.documentElement, { childList: true, subtree: true });"
    + "}"

    + "modifyLinks();"
  + "})();";
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


