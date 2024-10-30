# UTM Parameters Storage Tag

This GTM client-side tag extracts UTM parameters from the query string of the current URL and stores them in the browser's `localStorage` for tracking purposes. The stored parameters can be later used for analytics, attribution, or marketing purposes.

## Features
- Extracts common UTM parameters from the query string: `utm_source`, `utm_medium`, `utm_campaign`, `utm_term`, and `utm_content`.
- Stores these UTM parameters in `localStorage` with the prefix `gtm_`, e.g., `gtm_utm_source`.
- Maintains a timestamp to track when the UTM parameters were stored and ensures parameters are removed after 30 minutes if no new UTM parameters are detected.
- Safeguarded by permission checks to ensure the tag only accesses allowed data and components.

## How it Works
1. The tag checks for the presence of UTM parameters in the URL's query string.
2. For each UTM parameter found, it stores the value in `localStorage` with a `gtm_` prefix.
3. If UTM parameters are detected, it also stores a timestamp of when the parameters were added.
4. If no UTM parameters are found and 30 minutes have passed since the last update, the stored UTM values and the timestamp are cleared.


## Example Use Case
If the current page's URL is:

`https://example.com/?utm_source=google&utm_medium=cpc&utm_campaign=stop_polute_earth`

The tag will:
- Extract the UTM parameters `utm_source`, `utm_medium`, and `utm_campaign`.
- Store them in `localStorage` as:
  - `gtm_utm_source = google`
  - `gtm_utm_medium = cpc`
  - `gtm_utm_campaign = stop_polute_earth`
- Store a timestamp to track when the UTM parameters were saved.

## Installation

1. Download the `UTM to localStorage.tpl` file
2. In your GTM container go to `Templates`
3. Click `New` in the `Tag Templates` section
4. Click the 3 dots in the right top corner and click `Import`
5. Choose the file and save the tag
6. In the end add a new tag by choosing the `UTM to localStorage` from the `Custom` section of the Tag Types.
7. Save, debug and publish