# Cross-Domain Tracking - Server-Side Client Tag

## Overview

This **Google Tag Manager (GTM) server-side client tag** is responsible for processing incoming requests from the client-side tag to facilitate **cross-domain tracking**. It captures custom user IDs and UTM parameters, generating a script that modifies links on the page to include these tracking values.

## Features

- **Handles cross-domain requests**: Processes the query string parameters sent from the client-side tag, including allowed domains, cookie values, and UTM parameters.
- **UTM parameter handling**: Collects UTM parameters dynamically from the incoming request, ensuring marketing attribution data is passed along.
- **Custom user ID handling**: Appends a custom user ID (cookie-based) to URLs across different domains.
- **Dynamic link modification**: Generates and returns a JavaScript snippet that modifies all links on the page, adding the UTM parameters and user ID to the URLs.

## How It Works

1. **Path Verification**:  
   The server-side client checks the request path to ensure it matches `/crosslinker`. If it does, it proceeds to handle the request.

2. **Query Parameter Extraction**:  
   It extracts important query parameters such as:
   - **allowedDomains**: Domains where tracking is permitted.
   - **cookieName**: The name of the cookie containing the custom user ID.
   - **cookieValue**: The value of the user ID stored in the cookie.
   - **utmParams**: Collects any UTM parameters that begin with `gtm_utm_` from the request.

3. **Validation**:  
   Ensures that required parameters (`cookieName`, `cookieValue`, and `allowedDomains`) are present. If any required parameters are missing, a `400 Bad Request` is returned.

4. **Script Generation**:  
   The tag generates a JavaScript function that:
   - Normalizes the domain names (removes protocol and `www`).
   - Modifies all links on the page to append the custom user ID (cookie value) and any available UTM parameters retrieved from `localStorage`.
   - This JavaScript is returned to the client to be executed in the browser.

5. **Error Handling**:  
   If the path doesn’t match or required parameters are missing, appropriate error responses are sent (`404 Not Found` or `400 Bad Request`).

## Example Query String

A sample query string that this server-side tag would process:

`/crosslinker?allowedDomains=example.com&cookieName=custom_user_id&cookieValue=abc123&gtm_utm_campaign=summer_sale&gtm_utm_medium=email`


This would result in a script that appends the user ID (`abc123`) and UTM parameters to all relevant links on the page.

## Script Example

Here’s an example of the JavaScript that might be generated:

```js
(function() {
    var cookieName = 'custom_user_id';
    var cookieValue = 'abc123';
    var allowedDomains = ["example.com"];
    var utmParams = ["gtm_utm_campaign", "gtm_utm_medium"];

    function normalizeDomain(domain) {
        return domain.replace(/^https?:\/\//, '').replace(/^www\./, '').toLowerCase();
    }

    function addParamToUrl(url, paramName, paramValue) {
        var urlParts = url.split('?');
        var baseUrl = urlParts[0];
        var queryString = urlParts[1] || '';
        var params = new URLSearchParams(queryString);
        params.set(paramName, paramValue);
        return baseUrl + '?' + params.toString();
    }

    function modifyLinks() {
        var links = document.querySelectorAll('a[href]');
        Array.prototype.forEach.call(links, function(link) {
            var urlObj = document.createElement('a');
            urlObj.href = link.href;
            var normalizedLinkDomain = normalizeDomain(urlObj.hostname);
            var normalizedAllowedDomains = allowedDomains.map(function(domain) {
                return normalizeDomain(domain);
            });

            if (normalizedAllowedDomains.includes(normalizedLinkDomain)) {
                link.href = addParamToUrl(link.href, cookieName, cookieValue);
                utmParams.forEach(function(param) {
                    var paramValue = localStorage.getItem(param);
                    if (paramValue) {
                        link.href = addParamToUrl(link.href, param, paramValue);
                    }
                });
            }
        });
    }

    modifyLinks();
})();
```

## Installation

1. Download the `Cross-linker Client.tpl` file
2. In your GTM container go to `Templates`
3. Click `New` in the `Client Templates` section
4. Click the 3 dots in the right top corner and click `Import`
5. Choose the file and save the tag
6. In the end add a new tag by choosing the `Cross-linker Client` from the `Custom` section of the Client Types.
7. Setup, save, debug and publish
