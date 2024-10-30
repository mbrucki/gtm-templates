# True Hostname Variable Template

This custom variable template for Google Tag Manager extracts the top-level domain (TLD) from the hostname of the current URL. The variable will always return the last two segments of the hostname, which typically corresponds to the domain name and the top-level domain (e.g., `example.com`).

## Functionality

- Extracts the top-level domain from the current URL.
- Always returns the last two segments of the domain (e.g., `example.com` from `subdomain.example.com`).
- In cases where the hostname consists of only one or two parts (e.g., `localhost` or `example.com`), the full hostname is returned.

## Code Description

- The template checks whether the necessary permissions to access the URL components are granted.
- The hostname is extracted using GTM's sandboxed JavaScript API for accessing the URL.
- The last two parts of the hostname are extracted by splitting it by `.` and returning the last two elements.

## Permissions

This template uses the following Google Tag Manager permissions:
- `get_url`: To access the hostname of the current URL.

## Example

For a hostname like `subdomain.example.com`, the variable will return `example.com`.

For a simple hostname like `localhost` or `example.com`, the variable will return `localhost` or `example.com`, respectively.

## Use Cases

- Extracting the top-level domain to track events based on the domain name.
- Using the domain for analytics, segmentation, or redirect logic.

## Installation

1. Download the `True Hostname.tpl` file
2. In your GTM container go to `Templates`
3. Click `New` in the `Variables Templates` section
4. Click the 3 dots in the right top corner and click `Import`
5. Choose the file and save the tag
6. In the end add a new tag by choosing the `True Hostname` from the `Custom` section of the Variable Types.
7. Save, debug and publish