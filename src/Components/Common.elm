module Components.Common exposing (footer, fullscreen, fullscreenButton, header)

import Components.Utils exposing (black, blue, setAlpha, topRight, white, zeroMarginAndPadding)
import Css exposing (Style, auto, backgroundColor, batch, block, border3, borderBottom3, borderTop3, calc, center, color, cursor, display, em, fixed, fontSize, fontWeight, height, hidden, hover, int, left, letterSpacing, lighter, margin2, maxHeight, maxWidth, minus, overflow, padding4, pct, pointer, position, px, solid, textAlign, top, vh, vw, width, zIndex, zero)
import Html.Styled exposing (Html, div, h1, h3, img, span, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)



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
