# Cross-Domain Tracking Tag for Custom User ID and UTM Parameters

## Overview

This Google Tag Manager (GTM) custom template facilitates **cross-domain tracking** by dynamically appending a custom **user ID** (cookie-based) and **UTM parameters** to URLs, ensuring seamless tracking across domains. It helps maintain consistent attribution of user actions to marketing campaigns by passing these parameters to a **server-side GTM** container.

## Features

- **Cross-domain tracking**: The tag enables the transmission of user IDs and UTM parameters across different domains.
- **Custom user ID handling**: It reads a custom user ID (cookie value) and passes it along with the request.
- **UTM parameter support**: The tag supports five predefined UTM parameters (`utm_campaign`, `utm_source`, `utm_medium`, `utm_term`, `utm_content`), ensuring proper tracking of campaign data.
- **Dynamic URL construction**: It dynamically constructs the server-side URL using the `parseUrl` API, which extracts the protocol and hostname.

## Usage

This tag is designed to work within a GTM environment. It reads the necessary UTM parameters from `localStorage` and constructs a query string, which is sent to the server-side GTM container for further processing.
> **Note**: A server-side GTM setup is required for this tag to function correctly. The server-side container processes the incoming requests with user IDs and UTM parameters, ensuring proper tracking and attribution across domains. Make sure you've implemented the Cross-linker Client.
> **Note**: Moreover, to handle UTMs you have to provide a mechanism of saving them in the localStorage. See the `UTM to localStorage` Tag to find out more.

### Predefined UTM Parameters

- `utm_campaign`
- `utm_source`
- `utm_medium`
- `utm_term`
- `utm_content`

## How It Works

1. **Extracting Data**:
   - The tag extracts a custom user ID from a cookie (configured via the `cookieName`).
   - It fetches predefined UTM parameters from `localStorage`.
   
2. **URL Construction**:
   - The tag dynamically constructs the server-side URL using `parseUrl` and appends the user ID and available UTM parameters as query string parameters.

3. **Server-Side Request**:
   - It sends a request to the GTM server-side container via the `injectScript` API.

4. **Error Handling**:
   - If the user ID (cookie) is missing, the tag triggers the `gtmOnFailure` function.

## Configuration

1. **Allowed Domains**:
   - A list of allowed domains can be provided via the `data.allowedDomains` variable to restrict tracking to specific domains.

2. **Cookie Name**:
   - The `data.cookieName` defines the name of the cookie from which the user ID is retrieved.

## Example

Here’s an example of the generated query string:

`/crosslinker?allowedDomains=example.com&cookieName=custom_user_id&cookieValue=12345&utm_campaign=summer_sale&utm_medium=email&utm_source=google`


This query string is sent to the server-side GTM container, allowing the server to log or process cross-domain tracking data.

## Installation

1. Add this custom template tag to your GTM container.
2. Configure the allowed domains and cookie name via the GTM UI.
3. Ensure the UTM parameters (`utm_campaign`, `utm_source`, `utm_medium`, `utm_term`, `utm_content`) are available in `localStorage` for the tag to append them to the request.

## Debugging

The tag includes optional debugging via `logToConsole`, which outputs the generated URL and other relevant data. This can be enabled or reviewed during testing to verify the correct construction of the URL.
