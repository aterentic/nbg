module Components exposing (toggleFullscreen)

import Css exposing (Color, LengthOrAuto, Style, backgroundColor, batch, center, color, cursor, em, fontSize, height, hover, pointer, rgb, rgba, textAlign, width)
import Html.Styled exposing (Html, span, text)
import Html.Styled.Attributes exposing (class, css)
import Html.Styled.Events exposing (onClick)


white : Color
white =
    rgb 255 255 255


blue : Float -> Color
blue opacity =
    rgba 38 58 114 opacity


square : LengthOrAuto a -> Style
square size =
    batch [ width size, height size ]


toggleFullscreen : msg -> Html msg
toggleFullscreen onToggleClick =
    span
        [ class "fullscreen-button"
        , css
            [ cursor pointer
            , fontSize (em 2)
            , color white
            , square (em 1.5)
            , textAlign center
            , backgroundColor (blue 0.75)
            , hover [ backgroundColor (blue 1) ]
            ]
        , onClick onToggleClick
        ]
        [ text <| String.fromChar '⛶' ]
