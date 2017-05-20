import Html exposing (..)
import Html.Events exposing (..)
import Array
import Html.Attributes exposing (style, placeholder)

main : Program Never Model Msg
main =
  Html.beginnerProgram { model = init, view = view, update = update }


-- MODEL
type alias Model = { board : List String, currentPlayerToken : String }

init : Model
init = { board = ( List.repeat 9 ( "" ) ), currentPlayerToken = "X"  }


-- UPDATE
type Msg =
   PlayerMove String Int

update : Msg -> Model -> Model
update msg model =
    case msg of
       PlayerMove token position ->
         if token == "X" then
           { model | board = updateBoardSquare model.board position token, currentPlayerToken = "O" }
         else
           { model | board = updateBoardSquare model.board position token, currentPlayerToken = "X" }

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


-- VIEW
view : Model -> Html Msg
view model =
  div [ mainStyle ] [
      h2 [] [ text "Welcome to Tic Tac Toe using Elm!" ],
      table [] [
      tr [] (view_row model 0 1 2) ,
      tr [] (view_row model 3 4 5) ,
      tr [] (view_row model 6 7 8) ]]

view_row : Model -> Int -> Int -> Int -> List (Html Msg)
view_row model first second third =
  [
    td [] [ button [ onClick ( PlayerMove model.currentPlayerToken first ), cardStyle ] [ text ( Maybe.withDefault "" ( lookupBoardSquare model.board first ) ) ] ],
    td [] [ button [ onClick ( PlayerMove model.currentPlayerToken second ), cardStyle ] [ text ( Maybe.withDefault "" ( lookupBoardSquare model.board second ) ) ] ],
    td [] [ button [ onClick ( PlayerMove model.currentPlayerToken third ), cardStyle ] [ text ( Maybe.withDefault "" ( lookupBoardSquare model.board third ) ) ] ]
  ]

mainStyle =
    style
        [ ( "font-family", "-apple-system, system, sans-serif" )
        , ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "align-items", "center" )
        , ( "background-color", "#fafafa" )
        , ( "border", "lightgray solid 1px" )
        ]

cardStyle =
    style
        [ ( "background-color", "rgba(230, 126, 34,1.0)" )
        , ( "width", "200px" )
        , ( "height", "200px" )
        , ( "color", "white" )
        , ( "font-family", "-apple-system, system, sans-serif" )
        , ( "margin", "20px 20px 20px 20px" )
        , ( "cursor", "pointer" )
        , ( "font-size", "80px")
        , ( "box-shadow", "0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19)" )
        ]
