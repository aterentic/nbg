module Components exposing (PhotoView(..), almostWhite, blue, footer, header, photo, toggleFullscreen)

import Css exposing (Color, FontSize, LengthOrAuto, Style, absolute, backgroundColor, batch, block, borderBottom3, borderTop3, bottom, center, color, cursor, display, em, float, fontSize, fontWeight, height, hex, hidden, hover, letterSpacing, lighter, margin, margin4, overflow, padding, padding4, pct, pointer, position, px, relative, rgb, right, solid, textAlign, vw, width)
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, h1, h2, h3, img, span, text)
import Html.Styled.Attributes exposing (class, css, src)
import Html.Styled.Events exposing (onClick)


white : Color
white =
    rgb 255 255 255


almostWhite : Color
almostWhite =
    hex "#d6d6d6"


black : Color
black =
    rgb 0 0 0


blue : Color
blue =
    rgb 38 58 114


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
            , backgroundColor { blue | alpha = 0.75 }
            , hover [ backgroundColor blue ]
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


photoHeadline : String -> Float -> Float -> msg -> Html msg
photoHeadline headline bottomPercent delay headlineClick =
    h2
        [ css <|
            [ fontSize (em 1.5)
            , color almostWhite
            , backgroundColor { blue | alpha = 0.75 }
            , padding (em 0.5)
            , cursor pointer
            , margin4 (em 0) (em 0) (em 1) (pct 5)
            , position absolute
            , bottom (pct bottomPercent)
            , transition [ Css.Transitions.bottom3 500 delay Css.Transitions.ease ]
            , hover [ backgroundColor blue ]
            ]
        ]
        [ span [ onClick headlineClick ] [ Html.Styled.text headline ] ]


photo : PhotoView -> Photo -> msg -> msg -> Html msg
photo view { headline, text, image } headlineClick fullscreenClick =
    div
        [ css
            [ width (vw 100)
            , backgroundColor black
            , position relative
            ]
        , class "photo"
        , class <| photoClass view
        ]
        [ div
            [ css [ float right, overflow hidden ]
            , class "text"
            ]
            [ span
                [ css
                    [ padding4 (pct 4) (pct 8) (pct 0) (pct 0)
                    , display block
                    ]
                ]
                [ Html.Styled.text text ]
            ]
        , div
            [ css [ overflow hidden ]
            , class "container"
            ]
            [ img [ src image ] [] ]
        , case view of
            Article ->
                photoHeadline headline 8 0 headlineClick

            Teaser ->
                photoHeadline headline 0 500 headlineClick
        , toggleFullscreen fullscreenClick
        ]


zeroMarginAndPadding : Style
zeroMarginAndPadding =
    batch [ margin (px 0), padding (px 0) ]


defaultH : FontSize a -> Style
defaultH fs =
    batch [ zeroMarginAndPadding, fontSize fs, color almostWhite ]


header : String -> String -> Html msg
header headline description =
    Html.Styled.header
        [ css
            [ padding4 (em 1.5) (pct 0) (em 1.5) (pct 5)
            , borderBottom3 (px 1) solid almostWhite
            ]
        ]
        [ h1
            [ css [ defaultH (em 2), letterSpacing (em 0.2) ] ]
            [ text headline ]
        , h3
            [ css [ defaultH (em 1), fontWeight lighter ] ]
            [ text description ]
        ]


footer : Html msg
footer =
    div [ css [ borderTop3 (px 1) solid almostWhite ] ] []
