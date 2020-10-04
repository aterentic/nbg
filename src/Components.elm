module Components exposing (PhotoView(..), photo, toggleFullscreen)

import Css exposing (Color, LengthOrAuto, Style, backgroundColor, batch, center, color, cursor, em, fontSize, height, hover, pointer, rgb, rgba, textAlign, width)
import Html.Styled exposing (Html, div, h2, img, span, text)
import Html.Styled.Attributes exposing (class, css, src)
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


type PhotoView
    = Article
    | Teaser


type alias Photo =
    { headline : String
    , text : String
    , image : String
    }


photoClass : PhotoView -> String
photoClass pv =
    case pv of
        Article ->
            "article"

        Teaser ->
            "teaser"


photo : PhotoView -> Photo -> msg -> msg -> Html msg
photo view { headline, text, image } headlineClick fullscreenClick =
    div [ class "photo", class <| photoClass view ]
        [ div [ class "text" ] [ span [] [ Html.Styled.text text ] ]
        , div [ class "container" ] [ img [ src image ] [] ]
        , h2 [ class "headline" ] [ span [ onClick headlineClick ] [ Html.Styled.text headline ] ]
        , toggleFullscreen fullscreenClick
        ]
