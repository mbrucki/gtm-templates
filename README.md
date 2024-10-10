
# GTM Custom Tags, Variables, and Triggers

This repository contains custom-built Google Tag Manager (GTM) tags, variables, and triggers that can be used to enhance tracking and analytics implementations for various projects.

## Table of Contents

- [Introduction](#introduction)
- [Repository Structure](#repository-structure)
- [How to Use](#how-to-use)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository is designed to provide a collection of reusable custom tags, variables, and triggers for Google Tag Manager. These elements are developed to handle specific use cases that are not supported by the default GTM functionality, and can be easily imported into your own GTM container.

## Repository Structure

The repository is organized as follows:

```
/tags
   /customTag1.tpl
   /customTag2.js
/variables
   /customVariable1.tpl
   /customVariable2.js
/triggers
   /customTrigger1.json
   /customTrigger2.json
```

- **/tags**: Contains custom JavaScript files for custom GTM tags.
- **/variables**: Contains custom JavaScript files for custom GTM variables.
- **/triggers**: Contains trigger definitions in JSON format.

## How to Use

### Importing Tags, Variables, and Triggers

1. Download or clone the repository:

    ```bash
    git clone https://github.com/yourusername/gtm-custom-tags-variables-triggers.git
    ```

2. Open your GTM container in the [GTM Dashboard](https://tagmanager.google.com/).

3. Navigate to the **Tags**, **Variables**, or **Triggers** section depending on what you're importing.

4. Use the **Import** feature to add the JSON or JS files to your container.

## Contributing

If you'd like to contribute to this repository by adding new custom tags, variables, or triggers, please follow these steps:

1. Fork the repository.
2. Create a new feature branch:
   
    ```bash
    git checkout -b feature/new-tag-variable-trigger
    ```

3. Make your changes and test thoroughly.
4. Submit a pull request.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
