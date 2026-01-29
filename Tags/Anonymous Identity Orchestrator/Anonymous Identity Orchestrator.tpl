___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Anonymous Identity Orchestrator",
  "brand": {
    "id": "Mariusz Brucki",
    "displayName": "Mariusz Brucki"
  },
  "description": "The tag sets a cookie with the user anonymous id",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "cookie_name",
    "displayName": "Cookie name",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "cookie_value",
    "displayName": "Cookie value",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "cookie_domain",
    "displayName": "Cookie domain",
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "consent_checkbox",
    "checkboxText": "Check user\u0027s consent",
    "simpleValueType": true,
    "help": "The tag will proceed with setting up a cookie only if there is a consent for analytics."
  },
  {
    "type": "GROUP",
    "name": "consent_group",
    "displayName": "",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "consent_var",
        "displayName": "Consent variable",
        "simpleValueType": true,
        "help": "Variable storing the information about the user\u0027s consent"
      },
      {
        "type": "TEXT",
        "name": "consent_value",
        "displayName": "Consent value",
        "simpleValueType": true,
        "help": "Expected value of the consent variable when a user gives consent for tracking"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "consent_checkbox",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const queryPermission = require('queryPermission');
const setCookie = require('setCookie');
const getCookieValues = require('getCookieValues');
const getQueryParameters = require('getQueryParameters');
const makeString = require('makeString');
const Math = require('Math');
const logToConsole = require('logToConsole');

// --- Permissions ---
const cookieName = makeString(data.cookie_name || '').trim();
const canSetCookies = queryPermission('set_cookies', cookieName);
const canReadCookies = queryPermission('get_cookies', cookieName);
const canReadUrl = queryPermission('get_url', 'query');

// --- Helpers ---

function formatCookieDomain(domain) {
  var d = makeString(domain || '').trim().toLowerCase();
  if (!d) return '';

  // remove protocol if someone pasted a URL
  if (d.indexOf('http://') === 0) d = d.substring(7);
  if (d.indexOf('https://') === 0) d = d.substring(8);

  // strip path if present
  var slash = d.indexOf('/');
  if (slash >= 0) d = d.substring(0, slash);

  // ensure leading dot
  if (d.charAt(0) !== '.') d = '.' + d;

  return d;
}

function setCustomCookie(cname, cvalue, domain, exdays) {
  exdays = exdays || 365;

  if (!canSetCookies) {
    logToConsole('No permission to set cookie: ' + cname);
    data.gtmOnFailure();
    return;
  }

  // max-age is seconds-from-now (delta), not an epoch timestamp
  var maxAgeSeconds = Math.floor(exdays * 24 * 60 * 60);
  var formattedDomain = formatCookieDomain(domain);

  var nameStr = makeString(cname);
  var valueStr = makeString(cvalue);

  logToConsole('Setting cookie ' + nameStr + ' value="' + valueStr + '" domain=' + formattedDomain + ' maxAgeSeconds=' + maxAgeSeconds);

  setCookie(nameStr, valueStr, { domain: formattedDomain, path: '/', 'max-age': maxAgeSeconds });

  // readback to detect overwrites
  if (canReadCookies) {
    var after = getCookieValues(nameStr);
    var afterFirst = (after && after.length) ? after[0] : '';
    logToConsole('Cookie readback after set: firstValue="' + makeString(afterFirst) + '"');
  }
}

function getParameterByName(name) {
  if (!canReadUrl) {
    logToConsole('No permission to read URL query');
    data.gtmOnFailure();
    return '';
  }

  var key = makeString(name || '').trim();
  var qp = getQueryParameters(key);

  // Log type + first value safely (no JSON)
  var t = typeof qp;
  var first = '';

  // In sGTM, qp can be:
  // - an Array: ["ab130..."]
  // - a primitive string: "ab130..."
  // - a String object (typeof === "object") that is indexable => qp[0] === "a"
  if (qp == null) {
    logToConsole('getQueryParameters("' + key + '") => null/undefined');
    return '';
  }

  // Detect real array by checking for join() (cheap + works in sandbox)
  var isRealArray = (typeof qp === 'object' && qp !== null && typeof qp.join === 'function');

  if (isRealArray) {
    first = (qp.length && qp[0] != null) ? makeString(qp[0]) : '';
    logToConsole('getQueryParameters("' + key + '") type=array first="' + first + '"');
    return first;
  }

  // If it's not an array, treat it as a full value string (NOT qp[0])
  var full = makeString(qp);
  logToConsole('getQueryParameters("' + key + '") type=' + t + ' full="' + full + '"');

  return full;
}

// --- Consent inputs ---
const consentVar = data.consent_var;
const consentValue = data.consent_value;
const consentCheckbox = data.consent_checkbox === true;

// --- Main logic ---

// check existing cookie
var existingCookie = null;
if (canReadCookies) {
  var vals = getCookieValues(cookieName);
  existingCookie = (vals && vals.length) ? vals[0] : null;
}
logToConsole('Existing cookie "' + cookieName + '": "' + makeString(existingCookie) + '"');

if (existingCookie) {
  data.gtmOnSuccess();
  return;
}

// enforce consent if enabled
if (consentCheckbox) {
  if (makeString(consentVar) !== makeString(consentValue)) {
    logToConsole('Consent mismatch; not setting cookie');
    data.gtmOnFailure();
    return;
  }
}

// cookie missing -> try URL param -> else default
var valueFromUrl = getParameterByName(cookieName);
logToConsole('Value from URL: "' + makeString(valueFromUrl) + '"');

var finalValue = valueFromUrl ? valueFromUrl : makeString(data.cookie_value || '');
logToConsole('Final value to set: "' + makeString(finalValue) + '"');

setCustomCookie(cookieName, finalValue, data.cookie_domain, 365);

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
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
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
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
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
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
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 23/10/2024, 09:36:06


