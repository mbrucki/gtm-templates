___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "UTM to localStorage",
  "brand": {
    "id": "Mariusz Brucki",
    "displayName": "Mariusz Brucki"
  },
  "description": "Saves UTM parameters to localStorage",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const localStorage = require('localStorage'); 
const logToConsole = require('logToConsole'); 
const getQueryParameters = require('getQueryParameters');
const getTimestamp = require('getTimestamp'); 
const queryPermission = require('queryPermission');

// List of common UTM parameters
const utmParams = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content'];

let hasUTMParams = false;

// Iterate over each UTM parameter and check if it exists in the query parameters
for (let i = 0; i < utmParams.length; i++) {
  // Retrieve the query parameter for each UTM key
  if (queryPermission('get_url', 'query', utmParams[i])) {
    const paramValue = getQueryParameters(utmParams[i]); // Retrieve first value of the UTM parameter
    if (paramValue) {
      hasUTMParams = true;
      // Store UTM parameter in localStorage with the prefix "gtm_"
      if (queryPermission('access_local_storage', 'write', 'gtm_' + utmParams[i])) {
        localStorage.setItem('gtm_' + utmParams[i], paramValue);
        logToConsole('Stored: gtm_' + utmParams[i] + ' = ' + paramValue);
      } else {
        logToConsole('Permission denied: Cannot write to localStorage for ' + utmParams[i]);
      }
    }
  } else {
    logToConsole('Permission denied: Cannot read UTM parameter ' + utmParams[i]);
  }
}

if (hasUTMParams) {
  // Store the current timestamp in seconds
  getTimestamp(function(currentTime) {
    if (queryPermission('access_local_storage', 'write', 'gtm_timestamp')) {
      localStorage.setItem('gtm_timestamp', currentTime);
      logToConsole('Stored: gtm_timestamp = ' + currentTime);
    } else {
      logToConsole('Permission denied: Cannot write to localStorage for gtm_timestamp');
    }
  });
} else {
  // Check the timestamp if no UTM parameters are found
  if (queryPermission('access_local_storage', 'read', 'gtm_timestamp')) {
    const storedTimestamp = localStorage.getItem('gtm_timestamp');
    if (storedTimestamp) {
      getTimestamp(function(currentTime) {
        const thirtyMinutesInSeconds = 30 * 60;

        if (currentTime - storedTimestamp > thirtyMinutesInSeconds) {
          // If timestamp is older than 30 minutes, clear all UTM parameters and timestamp
          for (let i = 0; i < utmParams.length; i++) {
            if (queryPermission('access_local_storage', 'write', 'gtm_' + utmParams[i])) {
              localStorage.removeItem('gtm_' + utmParams[i]);
              logToConsole('Removed: gtm_' + utmParams[i]);
            }
          }
          localStorage.removeItem('gtm_timestamp');
          logToConsole('Removed: gtm_timestamp');
        } else {
          // Update the timestamp to the current time
          if (queryPermission('access_local_storage', 'write', 'gtm_timestamp')) {
            localStorage.setItem('gtm_timestamp', currentTime);
            logToConsole('Updated: gtm_timestamp = ' + currentTime);
          }
        }
      });
    }
  } else {
    logToConsole('Permission denied: Cannot read localStorage for gtm_timestamp');
  }
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
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
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 30/10/2024, 13:24:43


