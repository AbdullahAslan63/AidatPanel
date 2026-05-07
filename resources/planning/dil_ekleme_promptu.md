I have an existing Flutter project and I want to integrate localization using the slang (swe 1.6) package. The base folder structure is already prepared. I need a scalable and organized i18n architecture that separates core application strings from database-related and user-specific labels.

Please perform the following tasks:

- **Scan Project:** Analyze my current lib/ folder to understand the existing localization setup.

- **Namespace Strategy:** Organize strings.i18n.json using namespaces:
  - common: (e.g., login, cancel, errors)
  - features: (modular strings for future additions)
  - db_context: (placeholders or dynamic keys for data coming from the database).

- **Dynamic Content:** Implement templates for user-specific words using slang arguments (e.g., "user_entry": "Entry: {value}") so I can safely pass database values into localized strings.

- **Future-Proofing:** Set up the configuration to support Multiple Files. Create a structure where I can add strings_profile.i18n.json later without bloating the main file.

- **Integration:** Update my pubspec.yaml and generate a basic TranslationService wrapper to access these strings easily throughout the app (e.g., AppLocale.en.build().common.save).

Please ensure that existing translations are preserved and moved into the new 'common' or 'features' namespaces accordingly.
