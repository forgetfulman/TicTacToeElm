module Main exposing (..)

import Json.Decode exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (disabled)
import Array
import Http

import GameServerCommunicator exposing (..)
import BoardStyling exposing (..)


main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

type alias Board = List String

type GameStatus = NotPlaying | Playing | Draw | CrossWins | NoughtWins

-- MODEL
type alias Model = { board : Board, currentPlayerToken : String, gameStatus : GameStatus }

init : ( Model, Cmd Msg )
init = ( { board = ( List.repeat 9 ( " " ) ), currentPlayerToken = "X", gameStatus = NotPlaying  }
  , Cmd.none )


-- UPDATE
type Msg =
   StartNewGame | RequestNewGame ( Result Http.Error String ) | PlayerMove String Int Int | SendMove ( Result Http.Error String )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
     StartNewGame ->
       (model,
       makeNewGameRequest
         |> Http.send RequestNewGame)

     PlayerMove token x y ->
       if token == "X" then
         (model,
         makeMoveHttpRequest token (x, y)
           |> Http.send SendMove)
       else
         (model,
         makeMoveHttpRequest token (x, y)
           |> Http.send SendMove)

     RequestNewGame (Result.Ok updatedBoard) ->
       ( { model | board = ( decodeGameState updatedBoard ), currentPlayerToken = "X", gameStatus = ( decodeGameStatus updatedBoard ) }
       , Cmd.none )

     RequestNewGame (Result.Err errorMessage) ->
       Debug.log ("Unable to contact game server")
       ( model, Cmd.none )

     SendMove (Ok updatedBoard) ->
       if model.currentPlayerToken == "X" then
         ( { model | board = ( decodeGameState updatedBoard ), currentPlayerToken = "O", gameStatus = ( decodeGameStatus updatedBoard ) }
         , Cmd.none )
       else
         ( { model | board = ( decodeGameState updatedBoard ), currentPlayerToken = "X", gameStatus = ( decodeGameStatus updatedBoard ) }
         , Cmd.none )

     SendMove (Err updatedBoard) ->
       Debug.log ("Unable to contact game server")
       ( model, Cmd.none )

type Player = X | O

updateBoardSquare : List String -> Int -> String -> List String
updateBoardSquare list position token =
  let
     updateSquare squarePosition playerToken =
       if position == squarePosition then
         token
       else
         playerToken
  in
     List.indexedMap updateSquare list

lookupBoardSquare : List String -> Int -> Maybe String
lookupBoardSquare list position =
  Array.fromList list
    |> Array.get position

lookupBoardSquareToken : Model -> Int -> Int -> String
lookupBoardSquareToken model columnPosition rowPosition =
  Maybe.withDefault "" ( lookupBoardSquare model.board (rowPosition * 3 + columnPosition) )

decodeGameState : String -> List String
decodeGameState payload =
  case decodeString gameStateDecoder payload of
    Ok val -> val
    Err message -> ["Err"]

gameStateDecoder : Decoder ( List String )
gameStateDecoder = at [ "gameBoardState" ] (list string)

decodeGameStatus : String -> GameStatus
decodeGameStatus payload =
  case decodeString gameStatusDecoder payload of
    Ok val -> case val of
      "Playing" -> Playing
      "Draw" -> Draw
      "Crosses Wins" -> CrossWins
      "Nought Wins" -> NoughtWins
      _ -> NotPlaying
    Err message -> Debug.log message NotPlaying

gameStatusDecoder : Decoder String
gameStatusDecoder = at [ "gameStatus" ] string


-- VIEW
view : Model -> Html Msg
view model =
  div [ mainStyle ] [
    h2 [ gameTitleStyle ] [ text "Welcome to Tic Tac Toe using Elm!" ],
    p [] [ button [ onClick ( StartNewGame ), controlButtonStyle ] [ text "New Game" ] ],
    p [ gameStatusStyle ] [ textOf model.gameStatus ],
    table []
      [
        tr [] ( generateTableRow model (0, 0) (0, 1) (0, 2) ),
        tr [] ( generateTableRow model (1, 0) (1, 1) (1, 2) ),
        tr [] ( generateTableRow model (2, 0) (2, 1) (2, 2) )
      ]
  ]

textOf : GameStatus -> Html Msg
textOf gameStatus =
  case gameStatus of
    Playing -> text "Playing"
    NotPlaying -> text "Not Playing"
    NoughtWins -> text "O has won"
    CrossWins -> text "X has won"
    Draw -> text "There was a draw"

type alias BoardPosition = (Int, Int)

generateTableRow : Model -> BoardPosition -> BoardPosition -> BoardPosition -> List (Html Msg)
generateTableRow model first second third =
  [
    generateTableCell model ( Tuple.second (first) ) ( Tuple.first (first) ),
    generateTableCell model ( Tuple.second (second) ) ( Tuple.first (second) ),
    generateTableCell model ( Tuple.second (third) ) ( Tuple.first (third) )
  ]

generateTableCell : Model -> Int -> Int -> Html Msg
generateTableCell model columnPosition rowPosition =
  let
    squareToken = lookupBoardSquareToken model columnPosition rowPosition
    buttonStyling = configureSquareButton squareToken (model.gameStatus == Playing)
    buttonDisabled = isButtonDisabled squareToken model.gameStatus
    currentPlayerToken = model.currentPlayerToken
  in
    td [] [ generateButton currentPlayerToken squareToken buttonStyling buttonDisabled columnPosition rowPosition ]

generateButton : String -> String -> Attribute Msg -> Bool -> Int -> Int -> Html Msg
generateButton currentPlayerToken buttonToken buttonStyling isButtonDisabled columnPosition rowPosition =
  button [ onClick ( PlayerMove currentPlayerToken columnPosition rowPosition ), buttonStyling, disabled isButtonDisabled ] [ text buttonToken ]

isButtonDisabled : String -> GameStatus -> Bool
isButtonDisabled squareToken gameStatus =
  squareToken /= "" || gameStatus /= Playing


configureSquareButton : String -> Bool -> Attribute msg
configureSquareButton squareToken gameRunning =
  if squareToken == "" && gameRunning then
    enabledCardStyle
  else
    disabledCardStyle


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
