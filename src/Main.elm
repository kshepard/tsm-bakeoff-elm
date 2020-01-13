port module Main exposing (..)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, div, header, li, p, text)
import Html.Attributes exposing (class, id)
import Http
import Json.Decode as JD



---- MODEL ----


type Model
    = Loading
    | Failed String
    | Succeeded GeoJson


type alias GeoJson =
    { props : List (Maybe String)
    , raw : JD.Value
    }


type Msg
    = GotGeoJson (Result Http.Error GeoJson)


init : ( Model, Cmd Msg )
init =
    ( Loading, getGeoJson )



---- HTTP ----


getGeoJson : Cmd Msg
getGeoJson =
    Http.get
        { url = "Schools.geojson"
        , expect = Http.expectJson GotGeoJson geoJsonDecoder
        }


geoJsonDecoder : JD.Decoder GeoJson
geoJsonDecoder =
    JD.value
        |> JD.andThen
            (\value ->
                JD.map2 GeoJson
                    (JD.field "features"
                        (JD.list
                            (JD.field "properties"
                                (JD.field "TYPE_SPECIFIC" (JD.nullable JD.string))
                            )
                        )
                    )
                    (JD.succeed value)
            )



---- PORTS -----


port sendGeoJsonToClient : JD.Value -> Cmd msg



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotGeoJson (Ok geoJson) ->
            ( Succeeded geoJson, sendGeoJsonToClient geoJson.raw )

        GotGeoJson (Err error) ->
            ( Failed "Error fetching geojson", Cmd.none )



---- VIEW ----


view : Model -> Html msg
view model =
    div [ class "app" ]
        [ header [ class "header" ] [ text "TSM bakeoff: Elm" ]
        , div [ class "main" ]
            [ div [ class "sidebar" ] (viewSidebar model)
            , div [ class "map", id "map" ] []
            ]
        ]


viewSidebar : Model -> List (Html msg)
viewSidebar model =
    case model of
        Loading ->
            [ p [] [ text "Loading" ] ]

        Failed err ->
            [ p [] [ text err ] ]

        Succeeded geoJson ->
            [ p [ class "stats-heading" ] [ text "Stats" ] ]
                ++ viewStats (groupProps geoJson.props)


viewStats : Dict String Int -> List (Html msg)
viewStats groupedProps =
    groupedProps
        |> Dict.toList
        |> List.map
            (\( propName, count ) ->
                li []
                    [ text
                        (propName
                            ++ ": "
                            ++ String.fromInt count
                        )
                    ]
            )


groupProps : List (Maybe String) -> Dict String Int
groupProps props =
    props
        |> List.filterMap identity
        |> List.foldr
            (\prop acc ->
                Dict.update
                    prop
                    (\maybeCount -> Just (Maybe.withDefault 1 (Maybe.map (\c -> c + 1) maybeCount)))
                    acc
            )
            Dict.empty



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
