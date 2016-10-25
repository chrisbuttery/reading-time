module Main exposing (..)

import Html exposing (Html, text, div, button, h3)
import Html.App as App
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing ((:=))
import Task
import ReadingTime


type alias Model =
    { stats : Maybe ReadingTime.Stats
    , article : Maybe String
    , error : Maybe String
    }


type alias Article =
    { body : String
    }


initialModel : Model
initialModel =
    { stats = Nothing
    , article = Nothing
    , error = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


articleDecoder : Decode.Decoder Article
articleDecoder =
    Decode.object1 Article
        ("body" := Decode.string)


loadArticle : Int -> Cmd Msg
loadArticle i =
    let
        url =
            "https://jsonplaceholder.typicode.com/posts/" ++ (toString i)
    in
        Task.perform (toString >> LoadingFailed) ArticleLoaded (Http.get articleDecoder url)


type Msg
    = LoadArticle Int
    | ArticleLoaded Article
    | LoadingFailed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadArticle i ->
            ( model, loadArticle i )

        ArticleLoaded article ->
            let
                { body } =
                    article

                text =
                    ReadingTime.stats body Nothing
            in
                ( { model
                    | article = Just body
                    , stats = Just text
                  }
                , Cmd.none
                )

        LoadingFailed error ->
            ( { model | error = Just error }, Cmd.none )


loadButton : Int -> Html Msg
loadButton i =
    button [ onClick (LoadArticle i) ] [ "load #" ++ (toString i) |> text ]


renderStats stats =
    case stats of
        Nothing ->
            text ""

        Just stats ->
            h3 [] [ text ("Stats: " ++ (toString stats)) ]


view : Model -> Html Msg
view model =
    div []
        [ div []
            (List.map loadButton [1..5])
        , div []
            [ text (toString model)
            ]
        , renderStats model.stats
        ]


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }
