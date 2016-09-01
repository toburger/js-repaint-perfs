port module Opt exposing (..)

import Html exposing (Html, div, span, table, tbody, tr, td, text)
import Html.Attributes exposing (class)
import Html.App as Html
import Html.Lazy exposing (lazy)
import Html.Keyed as Keyed


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
    Keyed.node "tr"
        []
        ([ ( database.dbname ++ "-dbname"
           , td
                [ class "dbname" ]
                [ text database.dbname ]
           )
         , ( database.dbname ++ "-query-count"
           , td
                [ class "query-count" ]
                [ span
                    [ class database.lastSample.countClassName ]
                    [ text (toString database.lastSample.nbQueries) ]
                ]
           )
         ]
            ++ (List.map (viewKeyedTopFiveQueries database.dbname) database.lastSample.topFiveQueries)
        )


viewKeyedTopFiveQueries : String -> Query -> ( String, Html Msg )
viewKeyedTopFiveQueries dbname query =
    ( dbname ++ "-" ++ query.query, viewTopFiveQueries query )


view : Model -> Html Msg
view model =
    div
        []
        [ table
            [ class "table table-striped latest-data" ]
            [ Keyed.node "tbody"
                []
                (List.map viewKeyedDatabase model)
            ]
        ]


viewKeyedDatabase : Database -> ( String, Html Msg )
viewKeyedDatabase database =
    ( toString database.dbname, viewDatabase database )


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
