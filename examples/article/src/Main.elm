module Main exposing (..)

import Html exposing (text, Html, div, p, h1, span)
import Html.Attributes exposing (class)
import Html.App
import String
import Debug
import Ports
import ScrollProgress
import ReadingTime


-- MODEL


type alias AppModel =
    { progressModel : ScrollProgress.Model
    , stats : Maybe ReadingTime.Stats
    }


childModel : ScrollProgress.Model
childModel =
    { progress = 0
    , color = Nothing
    , to = Just "lightsalmon"
    , from = Just "lightseagreen"
    }


initialModel : AppModel
initialModel =
    { progressModel = childModel
    , stats = Nothing
    }


init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- STATIC ARTICLE


type alias Article =
    { title : String
    , author : String
    , copy : List String
    }


paragraphs : List String
paragraphs =
    [ "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\n  tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\n  quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo\n  consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse\n  cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non\n  proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\n  tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\n  quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo\n  consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse\n  cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non\n  proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    , "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\n  tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\n  quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo\n  consequat."
    , "Duis aute irure dolor in reprehenderit in voluptate velit esse\n    cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non\n    proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\n    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\n    quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo\n    consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse\n    cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non\n    proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    , "Vivamus ac diam lacus. Suspendisse potenti. Phasellus tempor nulla non tristique venenatis. Vivamus id scelerisque orci. Morbi hendrerit id mi eget feugiat. Vestibulum sit amet augue fermentum, feugiat tellus nec, mollis risus. Vestibulum eu accumsan odio, et porta tortor. Morbi cursus porta aliquet. Nunc ipsum neque, auctor sed nisi ut, auctor mattis odio. Integer sed mauris dolor. Mauris iaculis eu tortor eget laoreet. Sed ut urna id sapien vulputate feugiat ac a felis. Mauris ullamcorper, arcu nec aliquet iaculis, neque augue mollis lorem, sit amet tempus nulla lacus in neque. Donec iaculis ante sed mi scelerisque, ut sollicitudin ex accumsan."
    ]


article : Article
article =
    { title = "The Happy Panda"
    , author = "Story written by The Happy Panda"
    , copy = paragraphs
    }



-- MESSAGES


type Msg
    = ProgressMsg ScrollProgress.Msg



-- VIEW


renderStats : ReadingTime.Stats -> Html Msg
renderStats stats =
    let
        { duration, minutes, time, words } =
            stats
    in
        div [ class "stats" ]
            [ span [] [ text ("Duration: " ++ duration) ]
            , span [] [ text ("Minutes : " ++ toString minutes) ]
            , span [] [ text ("Time : " ++ toString time) ]
            , span [] [ text ("Words : " ++ toString words) ]
            ]


renderArticle stats content =
    let
        { title, copy, author } =
            content

        articleCopy =
            String.join " " copy

        stats =
            ReadingTime.stats articleCopy Nothing
    in
        div [ class "article" ]
            [ h1 [] [ text title ]
            , renderStats stats
            , div [ class "panda" ] []
            , div [] (List.map renderParagraph copy)
            , span [ class "author" ] [ text author ]
            ]


renderParagraph : String -> Html Msg
renderParagraph copy =
    p [] [ text copy ]


view : AppModel -> Html Msg
view model =
    div []
        [ Html.App.map ProgressMsg (ScrollProgress.view model.progressModel)
        , renderArticle model.stats article
        ]



-- UPDATE


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        ProgressMsg subMsg ->
            let
                ( updatedProgessModel, progressCmd ) =
                    ScrollProgress.update subMsg model.progressModel
            in
                ( { model | progressModel = updatedProgessModel }, Cmd.map ProgressMsg progressCmd )



-- SUBSCIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Ports.onScroll (ProgressMsg << ScrollProgress.Progress)



-- APP


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
