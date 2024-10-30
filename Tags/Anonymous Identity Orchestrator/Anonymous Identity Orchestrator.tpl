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
const getTimestampMillis = require('getTimestampMillis');
const getQueryParameters = require('getQueryParameters');
const makeString = require('makeString');
const Math = require('Math');

// Check permissions for setting and reading cookies
const canSetCookies = queryPermission('set_cookies', data.cookie_name);
const canReadCookies = queryPermission('get_cookies', data.cookie_name);
const canReadUrl = queryPermission('get_url', 'query');

// Function to set the cookie
function setCustomCookie(cname, cvalue, domain, exdays) {
    exdays = exdays || 365;

    if (!canSetCookies) {
        data.gtmOnFailure();
        return;
    }

    const currentTimeMillis = getTimestampMillis();
    const expiresMillis = currentTimeMillis + (exdays * 24 * 60 * 60 * 1000);
    const expiresSeconds = Math.floor(expiresMillis / 1000);

    // Always add a dot before the domain
    const formattedDomain = '.' + domain;

    // Set the cookie with the specified values
    setCookie(cname, cvalue, { domain: formattedDomain, path: '/', 'max-age': expiresSeconds });
}

// Function to get the parameter from the URL
function getParameterByName(name) {
    if (!canReadUrl) {
        data.gtmOnFailure();
        return "";
    }

    const queryParams = getQueryParameters(name);
    const paramValue = queryParams ? queryParams[0] || "" : "";

    return paramValue;
}

// Direct consent comparison
const consentVar = data.consent_var;  // Value provided in the UI
const consentValue = data.consent_value;  // Value provided in the UI
const consentCheckbox = data.consent_checkbox;  // Consent checkbox provided in the UI

// Check if the cookie already exists
const existingCookie = getCookieValues(data.cookie_name)[0] || null;
if (existingCookie) {
    data.gtmOnSuccess();
} else {
    // Proceed with consent check only if consentCheckbox is true
    if (consentCheckbox === true) {
        // Compare consent values
        if (makeString(consentVar) === makeString(consentValue)) {
            let cookieValue = getParameterByName(data.cookie_name);

            if (cookieValue) {
                // Set the cookie based on URL parameter
                setCustomCookie(data.cookie_name, cookieValue, data.cookie_domain);
            } else {
                // Use the default cookie value if not found in the URL
                cookieValue = data.cookie_value;
                setCustomCookie(data.cookie_name, cookieValue, data.cookie_domain);
            }

            data.gtmOnSuccess();
        } else {
            data.gtmOnFailure();
        }
    } else {
        // If consentCheckbox is not true, set the cookie always
        let cookieValue = getParameterByName(data.cookie_name);

        if (cookieValue) {
            // Set the cookie based on URL parameter
            setCustomCookie(data.cookie_name, cookieValue, data.cookie_domain);
        } else {
            // Use the default cookie value if not found in the URL
            cookieValue = data.cookie_value;
            setCustomCookie(data.cookie_name, cookieValue, data.cookie_domain);
        }

        data.gtmOnSuccess();
    }
}


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
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 23/10/2024, 09:36:06


