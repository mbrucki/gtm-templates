# Cookie Consent and URL Parameter Processor

This Google Tag Manager custom tag checks for consent before setting a cookie based on either a URL parameter or a default value. The tag will only set the cookie if the user has given the required consent. If a cookie already exists, it will not be overwritten. 

## How It Works

### Flow Overview:
1. **Check for Consent**: 
   - The tag compares the value of the user-provided consent variable (`consent_var`) with a predefined consent value (`consent_value`). 
   - If the values match, consent has been given, the tag will proceed to set a cookie.
   
2. **Check for Existing Cookie**:
   - Before setting the cookie, the tag checks if the cookie (`data.cookie_name`) already exists.
   - If the cookie exists, the tag exits without doing anything further.
   
3. **Set Cookie from URL Parameter or Default Value**:
   - If the cookie does not exist, the tag attempts to get a value for the cookie from a URL parameter (`data.cookie_name`).
   - If the URL parameter is present, it sets the cookie to that value.
   - If the URL parameter is not present, it uses the default cookie value (`data.cookie_value`) to set the cookie.

4. **Setting the Cookie**:
   - The cookie is set with a specified domain (`data.cookie_domain`), and it is stored for 365 days by default unless a different expiration time is provided.
   - The cookie is set with a dot (`.`) prepended to the domain name to ensure proper cross-domain functionality.

### Step-by-Step Flow:

1. **Permission Checks**:
   - The tag begins by checking for the necessary permissions to set and read cookies (`set_cookies`, `get_cookies`) and read URL parameters (`get_url`).
   
2. **Check Consent**:
   - The tag compares `consent_var` (provided in the UI) and `consent_value` (also provided in the UI) to ensure the user has given consent.
   
3. **Check for Existing Cookie**:
   - The tag checks if the cookie with the name specified in `data.cookie_name` already exists. If the cookie exists, it will not be overwritten, and the tag exits successfully.
   
4. **Check for URL Parameter**:
   - If no cookie exists, the tag checks for a URL parameter with the name of the cookie (`data.cookie_name`).
   
5. **Set Cookie**:
   - If the URL parameter exists, it sets the cookie to the value from the URL.
   - If the URL parameter does not exist, it uses the default value (`data.cookie_value`) to set the cookie.
   
6. **Cookie Properties**:
   - The cookie is set with a domain prepended with a dot (`.`), ensuring proper cross-domain functionality.
   - The cookie has a default expiration time of 365 days, which can be adjusted by providing a different value for `exdays`.

## Technical Details

### Parameters:

- `data.cookie_name`: The name of the cookie to be set. Also used to check for the URL parameter.
- `data.cookie_value`: The default value for the cookie if no URL parameter is found.
- `data.cookie_domain`: The domain for the cookie. A dot (`.`) is prepended to the domain to support cross-domain cookies.
- `data.consent_var`: The variable containing the user's consent status. This is compared with `data.consent_value`.
- `data.consent_value`: The value used to determine if consent has been granted (provided in the UI).

### Functions:

- **`setCustomCookie(cname, cvalue, domain, exdays)`**: This function sets the cookie with the specified name, value, domain, and expiration. The expiration defaults to 365 days.
- **`getParameterByName(name)`**: Retrieves the value of a URL parameter by name. If the parameter does not exist, it returns an empty string.
- **`getCookieValues(name)`**: Retrieves the value of an existing cookie by name.

### Example Use Case:

Suppose a website needs to set a unique user identifier (UUID) as a cookie, but only if the user has given consent. The site also allows setting this cookie from a URL parameter (`user_id`) if it exists. If no URL parameter is found, the cookie is set to a default value.

- **Scenario 1**: The user visits the page with consent given and a `user_id` in the URL. The cookie will be set to the value of `user_id`.
- **Scenario 2**: The user visits the page with consent given but no `user_id` in the URL. The cookie will be set to the default value provided.
- **Scenario 3**: The user visits the page without giving consent. No cookie will be set.
- **Scenario 4**: The user visits the page, and the cookie already exists. The tag does nothing, ensuring the existing cookie is preserved.

## Installation

1. Download the `Anonymous Identity Orchestrator.tpl` file
2. In your GTM container go to `Templates`
3. Click `New` in the `Tag Templates` section
4. Click the 3 dots in the right top corner and click `Import`
5. Choose the file and save the tag
6. In the end add a new tag by choosing the `Anonymous Identity Orchestrator` from the `Custom` section of the Tag Types.
7. Setup the tag, save, debug and publish

## Notes

- The cookie will only be set if consent is given and the cookie does not already exist.
- The cookie will either be set to a value from the URL or to a default value, depending on whether the URL parameter is present.
- Ensure that the correct domain and cookie names are provided in the UI when configuring this tag.
