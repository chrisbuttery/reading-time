module ReadingTime exposing (..)

{-| ReadingTime functions and Msg.

# Types
@docs Stats

# Regex
@docs stripTab, stripReturn, stripNewLine

# Functions
@docs countWords, getTime, report, stats, getRoundedReadingTime, getMinutes, getTime
-}

import Html exposing (text, Html, div)
import String
import Regex


{-| Stats type
-}
type alias Stats =
    { text : String
    , minutes : Float
    , time : Float
    , words : Int
    }


{-| Split a string and count it's length
-}
countWords : String -> Int
countWords str =
    if str == "" || str == " " then
        0
    else
        str
            |> String.split " "
            |> List.length


{-| Remove tabs from string
-}
stripTab : String -> String
stripTab str =
    str
        |> Regex.replace Regex.All (Regex.regex "\\t") (\_ -> "")


{-| Remove returns from string
-}
stripReturn : String -> String
stripReturn str =
    str
        |> Regex.replace Regex.All (Regex.regex "\\r") (\_ -> "")


{-| Remove new lines from string
-}
stripNewLine : String -> String
stripNewLine str =
    str
        |> Regex.replace Regex.All (Regex.regex "\\n") (\_ -> "")


{-| Rount up a Float and convert to string
-}
getRoundedReadingTime : Float -> String
getRoundedReadingTime minutes =
    ceiling minutes
        |> toString


{-| Calculate the minutes to read a string of words divided by option words per minute (wpm)
-}
getMinutes : Int -> Maybe Float -> Float
getMinutes words wpm =
    (toFloat words) / (Maybe.withDefault 200 wpm)


{-| Multiple a float value by 60 and then 1000
-}
getTime : Float -> Float
getTime minutes =
    minutes * 60 * 1000


{-| Return a specific Stats record
-}
report : Int -> Maybe Float -> Stats
report words wpm =
    let
        minutes =
            getMinutes words wpm
    in
        { text = (getRoundedReadingTime minutes) ++ " min read"
        , minutes = minutes
        , time = getTime minutes
        , words = words
        }


{-| Intitialise reporting
-}
stats : String -> Maybe Float -> Stats
stats str wpm =
    let
        words =
            str
                |> stripTab
                |> stripNewLine
                |> stripNewLine
                |> countWords
    in
        report words wpm
