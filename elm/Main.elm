port module Naive exposing (..)

import Html exposing (Html, div, span, table, tbody, tr, td, text)
import Html.Attributes exposing (class)
import Html.App as Html


type alias Query =
  { elapsedClassName : String
  , formatElapsed : String
  , query : String
  }


type alias LastSample =
  { countClassName : String
  , nbQueries : Int
  , topFiveQueries : List Query
  }


type alias Database =
  { dbname : String
  , lastSample : LastSample
  }


type alias Model =
  List Database


initialModel : Model
initialModel =
  []


type Msg
  = LoadData Model


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    LoadData model ->
      ( model, Cmd.none )


viewTopFiveQueries : Query -> Html Msg
viewTopFiveQueries query =
  td
    [ class ("Query " ++ query.elapsedClassName) ]
    [ text query.formatElapsed
    , div
        [ class "popover left" ]
        [ div
            [ class "popover-content" ]
            [ text query.query ]
        , div
            [ class "arrow" ]
            []
        ]
    ]


viewDatabase : Database -> Html Msg
viewDatabase database =
  tr
    []
    ([ td
        [ class "dbname" ]
        [ text database.dbname ]
     , td
        [ class "query-count" ]
        [ span
            [ class database.lastSample.countClassName ]
            [ text (toString database.lastSample.nbQueries) ]
        ]
     ]
      ++ (List.map viewTopFiveQueries database.lastSample.topFiveQueries)
    )


view : Model -> Html Msg
view model =
  div
    []
    [ text "OK"
    , table
        [ class "table table-striped latest-data" ]
        [ tbody
            []
            (List.map viewDatabase model)
        ]
    ]


port dispatchGenerateData : (Model -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
  dispatchGenerateData LoadData


main =
  Html.program
    { init = ( initialModel, Cmd.none )
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
