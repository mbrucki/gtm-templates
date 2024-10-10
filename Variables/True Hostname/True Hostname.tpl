___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "True Hostname",
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const queryPermission = require('queryPermission');
const getUrl = require('getUrl');

// Check if we have permission to read the URL host
const canReadUrl = queryPermission('get_url', 'host');

if (!canReadUrl) {
  return 'Error: No permission to access URL host';
}

// Retrieve the hostname using getUrl
var hostname = getUrl('host') || data.default_hostname;

if (!hostname) {
  return 'Error: Unable to retrieve hostname';
}

var domainParts = hostname.split('.');

// Return the last two parts of the domain
if (domainParts.length > 2) {
  return domainParts.slice(-2).join('.');
} else {
  // Return the full host for one- or two-part domains
  return hostname;
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
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
setup: ''


___NOTES___

Created on 10/10/2024, 15:57:45


