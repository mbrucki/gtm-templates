___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "SHA256 Hasher",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "This tag hashes the user\u0027s email using SHA-256, removes slashes from the Base64 result, checks for an existing user, and pushes the hashed email and user status to the dataLayer for tracking.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "userEmail",
    "displayName": "User Email",
    "simpleValueType": true,
    "help": "Email to be hashed"
  },
  {
    "type": "TEXT",
    "name": "triggered_event",
    "displayName": "Name of the event",
    "simpleValueType": true,
    "help": "Name of the event triggered after hashing an email"
  },
  {
    "type": "TEXT",
    "name": "event",
    "displayName": "Name of the event to pass",
    "simpleValueType": true,
    "help": "The value of the event that triggered the hasher. The value will be based in dL push as \u0027triggered_event\u0027."
  },
  {
    "type": "CHECKBOX",
    "name": "check_existing",
    "checkboxText": "Check if existing user",
    "simpleValueType": true,
    "help": "Include the \u0027existing_user\u0027 variable in dL push by comparing the hash with the value in the given cookie or other variable."
  },
  {
    "type": "GROUP",
    "name": "comparison",
    "displayName": "",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "existing_user_id",
        "displayName": "Existing user_id",
        "simpleValueType": true,
        "help": "Value to compare the hash with"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "check_existing",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const sha256 = require('sha256');
const createQueue = require('createQueue');

// Create the dataLayer queue
const dataLayerPush = createQueue('dataLayer');

// Perform the SHA-256 hashing with Base64 encoding
sha256(data.userEmail, function(finalHash) {
    // Remove slashes by splitting on '/' and joining back without them
    const safeFinalHash = finalHash.split('/').join('');  // Remove slashes '/'

    // Retrieve the encoded gp_user_id value from the data layer variable
    const encodedUserId = data.existing_user_id;

    // Check if the current user is an existing user based on hash comparison
    const isExisting = encodedUserId && safeFinalHash === encodedUserId;

    // Prepare the payload to push to the data layer
    const dataLayerPayload = {
        'event': data.triggered_event,  // This should be the GTM variable {{Event}} passed via the template
        'gp_user_id': safeFinalHash,
        'triggered_event': data.event  // Use the same event variable
    };

    // Conditionally add 'existing_user' only if check_existing is true
    if (data.check_existing) {
        dataLayerPayload.existing_user = isExisting;
    }

    // Push the data to the Data Layer using the dataLayer queue
    dataLayerPush(dataLayerPayload);

    // Indicate successful completion
    data.gtmOnSuccess();

}, function(error) {
    // Handle failure scenario
    data.gtmOnFailure();
}, { outputEncoding: 'base64' });


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
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
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
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
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 23/10/2024, 13:14:03


