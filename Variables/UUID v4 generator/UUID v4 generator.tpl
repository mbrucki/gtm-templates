___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "UUID v4 Generator",
  "description": "Generates and stores a unique UUID v4 once per page_view.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const generateRandom = require('generateRandom'); // Import the generateRandom function to create random numbers
const templateStorage = require('templateStorage'); // Import templateStorage to persist data across executions

// Check if UUID is already stored in templateStorage
let uuidV4 = templateStorage.getItem('uuidV4');

if (!uuidV4) {
  var hex = '0123456789abcdef'; // Hexadecimal characters used in UUID
  var uuid = '';

  // Loop through 36 characters to construct the UUID v4
  for (var i = 0; i < 36; i++) {
    // Add hyphens at the specific positions to match the UUID format
    if (i === 8 || i === 13 || i === 18 || i === 23) {
      uuid += '-';
    }
    // Set the version field to '4' for UUID v4
    else if (i === 14) {
      uuid += '4';
    }
    // Set the variant field between 8 and 11 for UUID v4
    else if (i === 19) {
      uuid += hex.charAt(generateRandom(8, 11));
    }
    // Generate a random hexadecimal character for other positions
    else {
      uuid += hex.charAt(generateRandom(0, 15));
    }
  }

  // Store the generated UUID in templateStorage
  templateStorage.setItem('uuidV4', uuid);
  uuidV4 = uuid;
}

// Return the existing or newly generated UUID
return uuidV4;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 09/10/2024, 13:35:29


