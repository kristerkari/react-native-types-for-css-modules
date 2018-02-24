# Typescript types for React Native CSS modules

[React Native Typescript types](https://www.npmjs.com/package/@types/react-native) with an extra added type: `className` property.

These types should be used together with [React Native CSS modules](https://github.com/kristerkari/react-native-css-modules).

## Installation

Replace normal `@types/react-native` installation...

```json
"@types/react-native": "^0.52.4",
```

...with this:

```json
"@types/react-native": "kristerkari/react-native-types-for-css-modules",
```

...and run `npm install` or `yarn install`.

If you want a specific version (only versions `>=0.52.4` are supported):

```json
"@types/react-native": "kristerkari/react-native-types-for-css-modules#v0.52.4",
```

## Updating new `@types/react-native` versions

To update `className` type to newer `@types/react-native` versions, you can use `ruby update_versions.rb`.
