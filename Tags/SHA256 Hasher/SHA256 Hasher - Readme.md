# Custom GTM Tag: SHA-256 Email Hash and User Check

This custom GTM tag hashes the user's email using SHA-256, removes slashes from the Base64 result, checks if the user is an existing user based on a stored `gp_user_id`, and pushes the relevant information into the `dataLayer` for tracking.

## Features
- **SHA-256 Email Hashing**: Hashes the user's email and encodes it using Base64.
- **Slash Removal**: Removes slashes (`/`) from the Base64-encoded hash to ensure it's URL-safe.
- **User Existence Check**: Optionally compares the hashed email to a pre-existing `gp_user_id` to determine if the user is already known.
- **Data Layer Push**: Pushes the hashed email and user status (`existing_user`) to `window.dataLayer`.

## Usage
This custom tag is designed for use within Google Tag Manager (GTM). It can be used to track hashed user information without exposing sensitive data like email addresses directly.

### Fields
1. **User Email**: The user's email address to be hashed.
2. **Existing user_id**: The pre-existing value for comparison (if applicable).
3. **Check if existing user**: Boolean flag to determine whether to check if the user is an existing user.
4. **Name of the event**: The name of the dL event to be pushed
5. **Name of the event to pass**: The GTM event to be passed from the original event as `triggered_event`. Recommended usage: `{{Event}}`

### Example Data Layer Push
```javascript
window.dataLayer.push({
    'event': 'custom_event',
    'gp_user_id': 'hashed_email_without_slashes',
    'existing_user': true,
    'triggered_event': 'petition_signup'
});
```

## Installation

1. Download the `SHA256 Hasher.tpl` file
2. In your GTM container go to `Templates`
3. Click `New` in the `Tag Templates` section
4. Click the 3 dots in the right top corner and click `Import`
5. Choose the file and save the tag
6. In the end add a new tag by choosing the `SHA256 Hasher` from the `Custom` section of the Tag Types.
7. Setup, save, debug and publish
