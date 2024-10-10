
# GTM Custom Tags and Variables teplates

This repository contains custom-built Google Tag Manager (GTM) tags and variables that can be used to enhance tracking and analytics implementations for various projects.

## Table of Contents

- [Introduction](#introduction)
- [Repository Structure](#repository-structure)
- [How to Use](#how-to-use)
- [License](#license)

## Introduction

This repository is designed to provide a collection of reusable custom tags and variables for Google Tag Manager. These elements are developed to handle specific use cases that are not supported by the default GTM functionality, and can be easily imported into your own GTM container.

## Repository Structure

The repository is organized as follows:

```
/tags
   /customTag1
      /customTag1.tpl
      /customTag1 - Readme.md
   /customTag2
      /customTag2.tpl
      /customTag2 - Readme.md
/variables
   /customVariable1
      /customVariable1.tpl
      /customVariable1 - Readme.md
   /customVariable2
      /customVariable2.tpl
      /customVariable2 - Readme.md
```

- **/tags**: Contains template files for custom GTM tags.
- **/variables**: Contains template files for custom GTM variables.


## How to Use

### Importing Tags, Variables,

1. Download or clone the repository:

    ```bash
    git clone https://github.com/mbrucki/gtm-templates
    ```

2. Open your GTM container in the [GTM Dashboard](https://tagmanager.google.com/).

3. Navigate to the **Tags**, **Variables** section depending on what you're importing.

4. Use the **Import** feature to add the tpl files to your container.


## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
