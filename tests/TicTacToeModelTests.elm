module TicTacToeModelTests exposing (all)

import Test exposing (..)
import Expect exposing (..)

import Main exposing (..)



all : Test
all =
    describe "Tic Tac Toe Model Tests"
        [ test "Test when a token has been placed in the top left board square that this is reported correctly" <|
            \() ->
                let
                    model = { board = ( ["X"] ++ List.repeat 8 ( "" ) ), currentPlayerToken = "O", gameStatus = "Playing" }
                in lookupBoardSquareToken model 0 0
                        |> Expect.equal "X",
          test "Test token is reported correctly from the model" <|
            \() ->
                let
                    model = { board = ( ["X"] ++ List.repeat 8 ( "" ) ), currentPlayerToken = "O", gameStatus = "Playing" }
                in Maybe.withDefault "" ( lookupBoardSquare model.board 0 )
                        |> Expect.equal "X"
        ]
