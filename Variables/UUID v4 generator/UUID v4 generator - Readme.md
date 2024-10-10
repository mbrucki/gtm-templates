# UUID v4 Generator

This custom macro for Google Tag Manager generates a unique UUID v4 (Universally Unique Identifier) once per `page_view`. The generated UUID is stored and reused for the duration of the `page_view` to ensure it remains consistent during the user session.

## Functionality

- Generates a unique UUID v4 string following the standard format (e.g., `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`).
- The UUID is generated using random hexadecimal values and adheres to the UUID v4 standard, where the version field is set to `4` and the variant field is set between `8` and `11`.
- Once generated, the UUID is stored in `templateStorage`, ensuring it persists throughout the page's lifecycle and is not regenerated during the same page view.
- The UUID is generated only once per `page_view` and reused for all subsequent requests on that page.

## Use Cases

- Can be used to track individual sessions or page views uniquely without requiring cookies or external storage.
- Useful for analytics purposes where a unique identifier is needed to associate events with a single page view.

## How It Works

1. **Random UUID Generation**: The template generates a 36-character UUID string by generating random hexadecimal digits for each position. The format includes hyphens at the 9th, 14th, 19th, and 24th positions.
2. **Storage in Template Storage**: The generated UUID is stored in `templateStorage`, a Google Tag Manager feature that persists values across executions for the same template. This ensures the UUID remains the same during the entire `page_view`.
3. **Reuse on Page View**: If a UUID is already stored, the macro retrieves it from `templateStorage` instead of generating a new one.

## Technical Details

### UUID Format

- The UUID follows the version 4 specification: `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`
  - `4` indicates the version.
  - `y` is one of the hexadecimal digits from `8` to `b`, indicating the variant.

### Example of a UUID v4:

f47ac10b-58cc-4372-a567-0e02b2c3d479


## Permissions

This template requires access to `templateStorage` to store and retrieve the UUID value. The following permission is required:

- **access_template_storage**: Used to store and retrieve the UUID v4 value across executions during the same `page_view`.

## Testing

This template has no specific test scenarios defined, but it can be tested by:
- Verifying that the UUID is consistent across the same page view.
- Ensuring that a new UUID is generated for each new page view.

