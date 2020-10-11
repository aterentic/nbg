module Components exposing (footer, fullscreen, fullscreenButton, header, photo)

import Components.Photo exposing (View(..))
import Css exposing (LengthOrAuto, Style, absolute, animationDelay, animationDuration, animationName, auto, backgroundColor, batch, block, border3, borderBottom3, borderTop3, bottom, calc, center, color, cursor, display, em, fixed, float, fontSize, fontWeight, height, hidden, hover, int, left, letterSpacing, lighter, margin, margin2, margin4, maxHeight, maxWidth, minus, num, opacity, overflow, padding, padding4, pct, pointer, position, property, px, relative, right, sec, solid, textAlign, top, vh, vw, width, zIndex, zero)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, h1, h2, h3, img, span, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import Utils exposing (..)



-- Elements


fullscreenButton : msg -> List Style -> Html msg
fullscreenButton onButtonClick moreStyles =
    let
        style =
            [ cursor pointer
            , fontSize (em 2)
            , color white
            , width (em 1.5)
            , height (em 1.5)
            , textAlign center
            , backgroundColor <| setAlpha blue 0.75
            , hover [ backgroundColor blue ]
            ]
    in
    span [ css <| moreStyles ++ style, onClick onButtonClick ] [ text "⛶" ]


type alias Photo =
    { headline : String
    , text : String
    , image : String
    }



-- image ratio is 4:3


photo : View -> Photo -> msg -> msg -> Float -> Float -> Html msg
photo view { headline, text, image } headlineClick fullscreenClick duration delay =
    div
        [ css <|
            [ width (vw 100)
            , backgroundColor black
            , position relative
            ]
                ++ (case view of
                        Article ->
                            -- displaying whole image (reduced to 50%): (50/4)*3vw
                            [ height (vw 37.5), transitions [ easeHeight ] duration 0 ]

                        Teaser ->
                            -- displaying 25% of an image: (25/4)*3vw
                            [ height (vw 18.75), transitions [ easeHeight ] duration delay ]
                   )
        ]
        [ Components.Photo.text view text duration delay
        , Components.Photo.container view image duration delay
        , Components.Photo.headline view headline duration delay headlineClick
        , case view of
            Article ->
                fullscreenButton fullscreenClick [ fadeIn duration delay, topLeft (pct 10) (pct 5) ]

            Teaser ->
                fullscreenButton fullscreenClick [ fadeOut duration 0, topLeft (pct 10) (pct 5) ]
        ]


zeroMarginAndPadding : Style
zeroMarginAndPadding =
    batch [ margin zero, padding zero ]


header : String -> String -> Html msg
header headline description =
    let
        default =
            batch [ zeroMarginAndPadding, color white ]
    in
    Html.Styled.header
        [ css
            [ padding4 (em 1.5) zero (em 1.5) (pct 5)
            , borderBottom3 (px 1) solid white
            ]
        ]
        [ h1
            [ css [ default, fontSize (em 2), letterSpacing (em 0.2) ] ]
            [ text headline ]
        , h3
            [ css [ default, fontSize (em 1), fontWeight lighter ] ]
            [ text description ]
        ]


footer : Html msg
footer =
    div [ css [ height (em 4), borderTop3 (px 1) solid white ] ] []


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
            , backgroundColor <| setAlpha black 0.75
            , overflow hidden
            ]
        ]
        [ img
            [ css
                [ maxWidth <| calc (vw 88) minus (px 2)
                , maxHeight <| calc (vh 88) minus (px 2)
                , border3 (px 2) solid <| setAlpha white 0.75
                , margin2 (vh 6) auto
                , display block
                ]
            , src source
            ]
            []
        , fullscreenButton fullscreenClick [ topRight (vh 6) (em 1) ]
        ]
