module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import ReadingTime


all : Test
all =
    describe "ReadingTime"
        [ test "countWords"
            <| \() ->
                let
                    string =
                        "I can't believe I ate the whole thing."

                    expected =
                        8

                    actual =
                        ReadingTime.countWords string
                in
                    Expect.equal expected actual
        , test "stripSymbols"
            <| \() ->
                let
                    string =
                        "I can't\x0D believe\n I ate \nthe whole \tthing."

                    expected =
                        "I can't believe I ate the whole thing."

                    actual =
                        string
                            |> ReadingTime.stripTab
                            |> ReadingTime.stripReturn
                            |> ReadingTime.stripNewLine
                in
                    Expect.equal expected actual
        , test "getMinutes"
            <| \() ->
                let
                    expected =
                        0.05

                    actual =
                        ReadingTime.getMinutes 10 Nothing
                in
                    Expect.equal expected actual
        , test "getTime"
            <| \() ->
                let
                    expected =
                        600000

                    actual =
                        ReadingTime.getTime 10
                in
                    Expect.equal expected actual
        , test "getRoundedReadingTime"
            <| \() ->
                let
                    expected =
                        "279"

                    actual =
                        ReadingTime.getRoundedReadingTime 278.39
                in
                    Expect.equal expected actual
        ]
