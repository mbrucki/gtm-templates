___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Cross-linker",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "This tag facilitates cross-domain-tracking for custom user_id and UTM parameters.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "cookieName",
    "displayName": "Cookie Name",
    "simpleValueType": true,
    "help": "Name of the cookie with user identifier"
  },
  {
    "type": "TEXT",
    "name": "allowedDomains",
    "displayName": "Allowed Domains",
    "simpleValueType": true,
    "help": "3rd party domains separated by comma for which additional parameters will be appended"
  },
  {
    "type": "TEXT",
    "name": "serverSideUrl",
    "displayName": "GTM Server-Side URL",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const getCookieValues = require('getCookieValues');
const encodeUriComponent = require('encodeUriComponent');
const localStorage = require('localStorage'); 
const parseUrl = require('parseUrl');  
const logToConsole = require('logToConsole'); 

// Use parseUrl to dynamically fetch hostname and protocol from data.serverSideUrl
const parsedUrl = parseUrl(data.serverSideUrl); 
const serverSideUrl = parsedUrl.protocol + '//' + parsedUrl.hostname;  

const allowedDomains = data.allowedDomains.trim().split(',').map(domain => domain.trim());
const cookieName = data.cookieName;

// Hardcoded UTM parameters
const utmParams = ['gtm_utm_campaign', 'gtm_utm_source', 'gtm_utm_medium', 'gtm_utm_term', 'gtm_utm_content'];

// Function to retrieve the cookie value using GTM API
function getCookieValue(name) {
  const values = getCookieValues(name);  
  return values.length > 0 ? values[0] : null;
}

// Function to retrieve UTM values from localStorage
function getUtmValues(utmParams) {
  const utmValues = {};
  
  // We iterate over each UTM parameter
  for (var i = 0; i < utmParams.length; i++) {
    const param = utmParams[i];  
    const value = localStorage.getItem(param);  
    if (value) {
      utmValues[param] = value; 
    }
  }
  return utmValues;
}

// Retrieve the cookie value
const cookieValue = getCookieValue(cookieName);

// If there is no cookie value, trigger gtmOnFailure
if (!cookieValue) {
  data.gtmOnFailure();
  return;
}

// Retrieve UTM values from localStorage
const utmValues = getUtmValues(utmParams);

// Create the query string for the server-side GTM request
let queryString = '?allowedDomains=' + encodeUriComponent(allowedDomains.join(',')) +
  '&cookieName=' + encodeUriComponent(cookieName) +
  '&cookieValue=' + encodeUriComponent(cookieValue);

// Add UTM parameters that exist in localStorage
for (var key in utmValues) {
  if (utmValues.hasOwnProperty(key)) {
    queryString += '&' + encodeUriComponent(key) + '=' + encodeUriComponent(utmValues[key]);
  }
}

// Full URL to the GTM server dynamically based on the parsed URL
const fullServerSideUrl = serverSideUrl + '/crosslinker' + queryString;

// Debugging output (Optional)
logToConsole("Generated fullServerSideUrl: " + fullServerSideUrl);

// Send request to the Server-Side GTM using injectScript
injectScript(fullServerSideUrl, data.gtmOnSuccess, data.gtmOnFailure);


___WEB_PERMISSIONS___

[
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
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://sgtmcz.greenpeace.org/"
              },
              {
                "type": 1,
                "string": "https://sgtmcz.greenpeace.cz/"
              },
              {
                "type": 1,
                "string": "https://sgtmcz.zachranmeoceany.cz/"
              },
              {
                "type": 1,
                "string": "https://sgtmcz.plastjepast.cz/"
              },
              {
                "type": 1,
                "string": "https://sgtmcz.zachranmeprirodu.cz/"
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
        "publicId": "access_local_storage",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gtm_utm_campaign"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gtm_utm_source"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gtm_utm_medium"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gtm_utm_term"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "gtm_utm_content"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
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

Created on 30/10/2024, 12:20:38


