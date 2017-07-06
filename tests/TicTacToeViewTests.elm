module TicTacToeViewTests exposing (all)

import Test exposing (..)
import Expect exposing (..)

import Main exposing (..)

import BoardStyling exposing (..)

all : Test
all =
    describe "Tic Tac Toe View Tests"
        [ test "Test a square's button is disabled when a token has been placed" <|
            \() ->
                isButtonDisabled "X" "Playing"
                    |> Expect.true "expected the button to be disabled",
          test "Testing a square's button is enabled when a token has not been placed" <|
              \() ->
                  isButtonDisabled "" "Playing"
                      |> Expect.false "expected the button to be enabled",
          test "Testing a square's button is disabled when a token has not been placed and the game is not being played" <|
              \() ->
                  isButtonDisabled "" "Crosses Win"
                      |> Expect.true "expected the button to be disabled",
          test "Testing a square's button is still disabled when a token has been placed and the game is not being played" <|
              \() ->
                  isButtonDisabled "X" "Crosses Win"
                      |> Expect.true "expected the button to be disabled",
          test "Testing a square's button is configured correctly depending on if it is disabled" <|
              \() ->
                  configureSquareButton "X" True
                      |> Expect.equal disabledCardStyle,
          test "Testing a square's button is configured correctly depending on if it is enabled" <|
              \() ->
                  configureSquareButton "" True
                      |> Expect.equal enabledCardStyle
        ]
