# TSM bakeoff: Elm

## Context

A simple example application that uses Elm to display some GeoJSON data on a map along with some basic stats.

The data used here is Philadelphia schools from: https://www.opendataphilly.org/dataset/schools/resource/b29d98a9-6b96-4742-aedc-80cac6398d1a

## Dependencies

* Elm
  * https://guide.elm-lang.org/install/elm.html
* This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app)
  * `npm install create-elm-app -g`


## Running

To start the application in debug mode, get a [Mapbox access token](https://docs.mapbox.com/help/how-mapbox-works/access-tokens/) and run:
```
ELM_APP_MAPBOX_TOKEN="<YOUR_TOKEN>" elm-app start
```
