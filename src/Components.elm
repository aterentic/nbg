module Components exposing (PhotoView(..), almostWhite, blue, footer, fullscreen, header, photo, toggleFullscreen)

import Css exposing (Color, FontSize, LengthOrAuto, Style, absolute, animationDelay, animationDuration, animationName, auto, backgroundColor, batch, block, border3, borderBottom3, borderTop3, bottom, calc, center, color, cursor, display, em, fixed, float, fontSize, fontWeight, height, hex, hidden, hover, int, left, letterSpacing, lighter, margin, margin2, margin4, maxHeight, maxWidth, minus, num, opacity, overflow, padding, padding4, pct, pointer, position, property, px, relative, rgb, right, sec, solid, textAlign, top, vh, vw, width, zIndex, zero)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, h1, h2, h3, img, s, span, text)
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


toggleFullscreen : msg -> Style -> Html msg
toggleFullscreen onToggleClick position =
    span
        [ css
            [ position
            , cursor pointer
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
            , margin4 zero zero (em 1) (pct 5)
            , position absolute
            , bottom (pct bottomPercent)
            , transition [ Css.Transitions.bottom3 500 delay Css.Transitions.ease ]
            , hover [ backgroundColor blue ]
            ]
        ]
        [ span [ onClick headlineClick ] [ Html.Styled.text headline ] ]


fadeIn : Keyframes {}
fadeIn =
    keyframes
        [ ( 0, [ Css.Animations.opacity (num 0) ] )
        , ( 100, [ Css.Animations.opacity (num 100) ] )
        ]


fadeOut : Keyframes {}
fadeOut =
    keyframes
        [ ( 0, [ Css.Animations.opacity (num 100) ] )
        , ( 100, [ Css.Animations.opacity (num 0) ] )
        ]


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
                    [ padding4 (pct 4) (pct 8) zero zero
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
        , case view of
            Article ->
                let
                    animation =
                        batch
                            [ opacity zero
                            , animationName fadeIn
                            , animationDuration (sec 0.5)
                            , animationDelay (sec 0.5)
                            , property "animation-fill-mode" "forwards"
                            ]
                in
                toggleFullscreen fullscreenClick <| batch [ animation, position absolute, top (pct 10), left (pct 5) ]

            Teaser ->
                let
                    animation =
                        batch
                            [ opacity (num 100)
                            , animationName fadeOut
                            , animationDuration (sec 0.5)
                            , animationDelay (sec 0)
                            , property "animation-fill-mode" "forwards"
                            ]
                in
                toggleFullscreen fullscreenClick <| batch [ animation, position absolute, top (pct 10), left (pct 5) ]
        ]


zeroMarginAndPadding : Style
zeroMarginAndPadding =
    batch [ margin zero, padding zero ]


defaultH : FontSize a -> Style
defaultH fs =
    batch [ zeroMarginAndPadding, fontSize fs, color almostWhite ]


header : String -> String -> Html msg
header headline description =
    Html.Styled.header
        [ css
            [ padding4 (em 1.5) zero (em 1.5) (pct 5)
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


fullscreen : msg -> String -> Html msg
fullscreen fullscreenClick source =
    div
        [ css
            [ position fixed
            , width (pct 100)
            , height (vh 100)
            , zIndex (int 1)
            , top (px 0)
            , left (px 0)
            , overflow auto
            , backgroundColor { black | alpha = 0.75 }
            , overflow hidden
            ]
        ]
        [ img
            [ css
                [ maxWidth <| calc (vw 88) minus (px 2)
                , maxHeight <| calc (vh 88) minus (px 2)
                , border3 (px 2) solid { white | alpha = 0.75 }
                , margin2 (vh 6) auto
                , display block
                ]
            , src source
            ]
            []
        , toggleFullscreen fullscreenClick <| batch [ position absolute, top (vh 6), right (em 1) ]
        ]
