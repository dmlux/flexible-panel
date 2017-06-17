# Atom Flexible-Panels

An Atom package that provides a customizable panel for Atoms Docks introduced with version 1.17

<p align="left">
  <img src="https://img.shields.io/dub/l/vibe-d.svg" alt="License MIT">
  <img src="https://img.shields.io/badge/version-1.0.0-orange.svg" alt="Package version">
</p>

<p align="center">
  <img src="https://github.com/dmlux/flexible-panel/blob/master/screenshots/preview.gif?raw=true">
</p>



## Introduction

An Atom package that provides a customizable panel for Atoms Docks introduced with version 1.17. This panel can log all kind of information and displays them as a table. The table columns can be customized before panel creation to provide a simple insert logic. Once a specific configuration is attached to a column all its added contents will get the same configuration and hence will get the same style. The Flexible-Panel view also provides special column types like time columns or label columns. For further information see the examples section.

## Set Up

To be able to use Flexible-Panels in your project you have to include the following properties to your `package.json` file

```json
"consumedServices": {
  "flexible-panels": {
    "versions": {
      ">=1.17.0": "consumeFlexiblePanels"
    }
  }
}
```

You should have installed this package to consume the service mentioned in the property above. If you develop packages and need this package as a dependency we recommend using the `npm` library [Atom-Package-Deps](https://www.npmjs.com/package/atom-package-deps).

In your main package file you should also include the following function in Coffeescript:

```coffeescript
  consumeFlexiblePanels: (flexiblePanelsManager) ->
    # Create flexible panel view and add entries here...
```

If you are coding in Javascript instead the following function has to be added:

```javascript
  consumeFlexiblePanels(flexiblePanelsManager) {
    // Create flexible panel view and add entries here...
  }
```
It is important that the consume function gets exported. In the example above we assume that the function is included in the export default scope. If you separately export each function you have to add an export to the consume function.

The `consumeFlexiblePanels` function is called once your package gets activated. It will give you a `FlexiblePanelManager` object as an argument. You can use the manager to create new Flexible-Panel-Views.



## API

The following classes and methods can be used to interact with Flexible-Panel instances.

### `FlexiblePanelManager`

A class that is able to create a Flexible-Panel view. It keeps track of all created views and will clean up on destruction. To get correctly working Flexible-Panel views only create those views via this manager.

#### `::createFlexiblePanel(config)`

Creates a new Flexible-Panel view instance that will be embedded into workspace automatically.



## Examples



## Authors
- [Denis-Michael Lux](https://www.github.com/dmlux/)<sup>(owner)</sup>
