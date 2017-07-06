module GameServerCommunicator exposing (..)

import Http

gameServerUrl : String
gameServerUrl = "http://localhost:8080"

newGameRequest : String
newGameRequest = "/newGame"

gameBoardRequest : String
gameBoardRequest = "/"

makeMoveRequest : String
makeMoveRequest = "/makeMove"

makeNewGameRequest : Http.Request String
makeNewGameRequest =
  Http.getString ( gameServerUrl ++ newGameRequest )

makeMoveHttpRequest : String -> (Int, Int) -> Http.Request String
makeMoveHttpRequest playerToken point =
  Http.getString (gameServerUrl ++ makeMoveRequest ++ "?player="++ playerToken ++ "&pointX=" ++ toString ( Tuple.first (point) ) ++ "&pointY=" ++ toString ( Tuple.second (point) ) )
