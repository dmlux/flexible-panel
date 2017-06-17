<p align="left">
  <img src="https://img.shields.io/dub/l/vibe-d.svg" alt="License MIT">
  <img src="https://img.shields.io/badge/version-1.0.0-orange.svg" alt="Package version">
</p>

# Atom Flexible-Panels
An Atom package that provides a customizable panel for Atoms Docks introduced with version 1.17

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

In your main package file you should also include the following function:
```javascript
  consumeFlexiblePanels(flexiblePanelsManager) {
    // Create flexible panel view and add entries here...
  }
```
It is important that the consume function gets exported. In the example above we assume that the function is included in the export default scope. If you separately export each function you also have to add an export to the consume function.

The `consumeFlexiblePanels` function is called once your package gets activated. It will give you a `FlexiblePanelManager` object as an argument. You can use the manager to create new Flexible-Panel-Views.



## API
The following classes and methods can be used to interact with Flexible-Panel instances.

### `FlexiblePanelManager`
A class that is able to create a Flexible-Panel view. It keeps track of all created views and will clean up on destruction. To get correctly working Flexible-Panel views only create those views via this manager.

#### `::createFlexiblePanel(config)`
Creates a new Flexible-Panel view instance that will be embedded into workspace automatically. The config object contains settings for the Flexible-Panel view that will be created. The method returns a promise that has to be resolved before it can be used to store data. The following settings can be changed via the config object:

* `addClearButton` `<boolean>` Adds a button that can clear the table entries. The default value is set to `yes`/`true`.
* `addSaveButton` `<boolean>` Adds a button that will save the table contents. The default value is set to `yes`/`true`.
* `allowedLocations` `<array<string>>` Specifies other allowed docks for the view. The value is an array containing any combination of the above described locations.

  **Note**: make sure to always contain the default location in this array to avoid undefined behavior. The default value is set to `['bottom']`.
* `columns` `<array<object>>` An array of column specifications. The default value is `[]`
* `defaultLocation` `<string>` Specifies the dock in which the view should be opened. Allowed locations are `left`, `bottom`, `right`, `top` and `center`. The default location is `bottom`.
* `hideCellBorders` `<boolean>` Hides all borders of each table cells. The default value is `no`/`false`.
* `hideHorizontalCellBorders` `<boolean>` Hides only the horizontal borders of each table cell. The default value is `no`/`false`.
* `hideTableHead` `<boolean>` Hides the fixed header which contains the column names. If this is set to `no`/`false` the background color of the row elements is set to the table heads background color. The default value for this property is `no`/`false`.
* `hideVerticalCellBorders` `<boolean>` Hides only the vertical borders of each table cell. The default value is `no`/`false`.
* `labels` `<array<object>>` An array with label specifications. The default value is `[]`.
* `maxLines` `<number>` Defines the maximal amount of lines that can get added to the table view. The default value is set to `500`.
* `title` `<string>` The title in the tab of the corresponding Flexible-Panel view
* `useMonospaceFont` `<boolean>` Uses monospace font for the table. The default value is `no`/`false`.

The column specification array contains an object of properties for each column. The columns are ordered the same way the array is. The column specification object has the following properties

* `align` `<string>` Specifies the column alignment. The value can be `left`, `center` or `right`. The default value is `left`
* `fixedWidth` `<number>` Specifies the absolute width. If this value is set to a number unequals 0 then the column will keep this size even if the table size changes. If the value is set to 0 the column width will be set dynamically. The default value is `0`.

  **Note**: If all columns in the table will have dynamic column widths the result may not be as expected. Therefore it makes sense to fix some columns in size and let the other columns take up the rest of available width.
* `indentWrappedText` `<boolean>` If this value is set to `yes`/`true` the text which is wrapped automatically will be indented to the right. This increases readability for columns containing long texts. The default value is `no`.
* `name` `<string>` This property specifies the name of the column. The name will be displayed in the fixed table header. The default value is `Column <number>` where number is the index of the column starting with `1`;
* `type` `<string>` This property specifies which type of data is displayed in the column. The value should be `text`, `label` or `time` where `text` represents plain text, `label` is a colored text badge and `time` is the time when the entry was inserted into the table.

The label specification is similar to the column specification. A label is colored rectangle filling the available width and height of the table cell. The label is colored as specified. Labels allowing users to get a quick overview of what information was entered the table view without reading contents in detail. Each object in the label array should has the following properties:

* `background` `<string>` The background color in CSS representation. The default value is `inherit`.
* `color` `<string>` The font color in CSS representation. The default value is `inherit`.
* `type` `<string>` The label identifier as well as the text that gets displayed in the table view. The default value is `none`.

### `FlexiblePanelView`
The class represents the actual Flexible-Panel view.

#### `::addEntry(entry)`
This method adds an entry to the table view.

* `entry` `<array<string>>` The entry array contains a string for each column in the table. If the array contains less strings than the table has columns it gets filled with empty strings.

  **Note**: If a column in the table is of type `time` then it does not matter which value the entry contains on this position in the array since it gets overwritten with the current time value. If the column is of type label the string should match on in the labels specification array passed to the `FlexiblePanelManager` on Flexible-Panel view creation.

#### `::getTitle()`
Returns the title of the given Flexible-Panel.

#### `::getURI()`
Returns the unique URI of the given Flexible-Panel.

#### `::getDefaultLocation()`
Returns the default location of the given Flexible-Panel

#### `::getAllowedLocations()`
Returns an array of allowed locations of the given Flexible-Panel



## Examples
In this section we will give a few examples on how the Flexible-Panel view can be customized and configured.

The following example will become a simple command log for IDE like packages:
```javascript
  consumeFlexiblePanels(flexiblePanelsManager) {
    // specify the columns for the flexible panel view
    const cols = [
      {name: 'Type', align: 'center', fixedWidth: 65, type: 'label'},
      {name: 'Description', indentWrappedText: true},
      {name: 'Time', align: 'center', fixedWidth: 95, type: 'time'}
    ];

    // specify the labels that can be used within the view
    const lbls = [
      {type: 'command', background: '#F75D59', color: '#fff'},
      {type: 'message', background: '#3090C7', color: '#fff'},
      {type: 'log', background: '#8E5287', color: '#fff'}
    ]

    // a variable that will keep the actual view
    let consoleView = null

    // get the view from the view manager. Since we get a promise we have to
    // resolve it and store the resolved view element in our variable
    const promise = flexiblePanelsManager.createFlexiblePanel({
      title: 'Console',
      columns: cols,
      labels: lbls,
      useMonospaceFont: true
    });

    // resolve promise to get the actual view element
    promise.then((view) => {
      consoleView = view;
      consoleView.addEntry(['command', 'mkdir /Users/dlux/Desktop/test', '']);
      consoleView.addEntry(['command', 'mkdir /Users/dlux/Desktop/test/build', '']);
      consoleView.addEntry(['command', 'touch /Users/dlux/Desktop/test/main.c', '']);
      consoleView.addEntry(['message', 'Successfully created directories and main.c file', '']);
      consoleView.addEntry(['log', 'veeeeeeery -long -command -with a lot -of --parameters and -flags that' +
        '-should -be -wrapped -to next -line -automatically', '']);
    });
  }
```
The result looks as follows
<p align="center">
  <img src="https://github.com/dmlux/flexible-panel/blob/master/screenshots/example-1.png?raw=true">
</p>

If you want to develop a Linter like package the following configuration may be the right

```javascript
  consumeFlexiblePanels(flexiblePanelsManager) {
    // specify the columns for the flexible panel view
    const cols = [
      {name: 'Type', align: 'center', fixedWidth: 60, type: 'label'},
      {name: 'Description', indentWrappedText: true}
    ]

    const lbls = [
      {type: 'error', background: '#F63E2E', color: '#fff'},
      {type: 'warning', background: '#FFA437', color: '#fff'}
    ]

    // a variable that will keep the actual view
    let consoleView = null;

    // get the view from the view manager. Since we get a promise we have to
    // resolve it and store the resolved view element in our variable
    const promise = flexiblePanelsManager.createFlexiblePanel({
      title: 'Console',
      columns: cols,
      labels: lbls,
      hideVerticalCellBorders: true,
      hideTableHead: true,
      addSaveButton: false,
      addClearButton: false
    })

    // resolve promise to actual view element
    promise.then((view) => {
      consoleView = view;
      consoleView.addEntry(['warning', 'comparison between pointer and integer']);
      consoleView.addEntry(['error', 'floppyto.c:782: parse error at end of input']);
      consoleView.addEntry(['error', 'usr/lib/crt0.o: Undefined symbol _main referenced from text segment']);
      consoleView.addEntry(['error', 'Undefined symbol _initscr referenced from text segment']);
      consoleView.addEntry(['warning', 'passing arg 1 of \'cpystr\' makes integer from pointer']);
      consoleView.addEntry(['error', 'parse error at end of input']);
      consoleView.addEntry(['warning', 'implicit declaration of function `...\'']);
    })
  }
```
The result looks as follows:
<p align="center">
  <img src="https://github.com/dmlux/flexible-panel/blob/master/screenshots/example-2.png?raw=true">
</p>

## Authors
- [Denis-Michael Lux](https://www.github.com/dmlux/)<sup>(owner)</sup>
