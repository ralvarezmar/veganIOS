# `NavigationConfigMap` & `NavigationConfig`

This type refers to the final variable that can contain the map that gathers the relationship between the project identifier and the final url in the Shell.

``` ts
/** Type that contains the information of an specific navigationConfig*/
export type NavigationConfig = {
  /** The entrypoint root */
  root: string;
  /** The specific entrypoint */
  entryPoints?: Map<string, string>;
};

/** Type that will be used for typing the global json file with the navigation configs */
export type NavigationConfigMap = {
  /** Map containing every navigation config */
  [key: string]: NavigationConfig;
};
```

## Example usages

Example `json` file that fits this type:

``` json
{
  "f-ng-00000000-pg-microfront": {
    "root": "ng15",
    "entryPoints": {
      "1": "first-child",
      "2": "second-child",
      "laboratory":"laboratory",
      "laboratoryExternal":"laboratory/external-navigate"
    }
  },
  "f-ng-00000000-pg-microfront-b": {
    "root": "ng15b",
    "entryPoints": {
      "1": "first-child",
      "2": "second-child",
      "laboratory":"laboratory",
      "laboratoryExternal":"laboratory/external-navigate"
    }
  },
  "f-ng-00000000-pg-microfront-c": {
    "root": "ng15c",
    "entryPoints": {
      "1": "first-child",
      "2": "second-child",
      "laboratory":"laboratory",
      "laboratoryExternal":"laboratory/external-navigate"
    }
  }
}
```
