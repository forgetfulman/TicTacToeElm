module BoardStyling exposing (..)

import Html.Attributes exposing (style)
import Html exposing (Attribute)

mainStyle : Attribute msg
mainStyle =
  style
    [ ( "font-family", "-apple-system, system, sans-serif" )
    , ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "align-items", "center" )
    , ( "background-color", "#fafafa" )
    , ( "border", "lightgray solid 1px" )
    ]

cardStyle : List ( String, String )
cardStyle =
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

enabledCardStyle : Attribute msg
enabledCardStyle =
  style ( List.append cardStyle
    [ ( "cursor", "pointer" ) ]
    )

disabledCardStyle : Attribute msg
disabledCardStyle =
  style ( List.append cardStyle
    [ ( "opacity", "0.65" )
    , ( "cursor", "not-allowed" )
    ] )

controlButtonStyle : Attribute msg
controlButtonStyle =
  style
    [ ( "background-color", "rgba(102, 153, 255,1.0)" )
    , ( "width", "200px" )
    , ( "height", "50px" )
    , ( "color", "white" )
    , ( "font-family", "-apple-system, system, sans-serif" )
    , ( "cursor", "pointer" )
    , ( "font-size", "30px")
    , ( "box-shadow", "0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19)" )
    ]

gameStatusStyle : Attribute msg
gameStatusStyle =
  style
    [ ( "font-family", "-apple-system, system, sans-serif" )
    , ( "font-size", "40px")
    , ( "text-align", "center" )
    ]

gameTitleStyle : Attribute msg
gameTitleStyle =
  style
    [ ( "font-family", "-apple-system, system, sans-serif" )
    , ( "font-size", "50px")
    , ( "text-align", "center" )
    ]
