module Components.Photo exposing (articleImage, articleText, teaserImage)

import Components.Utils exposing (black, gray, white)
import Css exposing (block, border3, color, display, em, float, fontSize, fontWeight, height, hidden, left, lighter, margin4, marginTop, overflow, padding4, pct, property, px, right, solid, width, zero)
import Html.Styled exposing (Html, div, img, span, text)
import Html.Styled.Attributes exposing (css, src)


articleText : String -> Html msg
articleText value =
    div
        [ css [ width (pct 50), height (pct 100), float right, overflow hidden ] ]
        [ span
            [ css
                [ padding4 (pct 4) (pct 8) zero zero
                , display block
                , color white
                , fontSize (em 1.33)
                , fontWeight lighter
                ]
            ]
            [ text value ]
        ]


teaserImage : String -> Html msg
teaserImage imgSrc =
    div
        [ css [ width (pct 100) ] ]
        [ img
            [ css
                [ width (pct 100)
                , marginTop (pct -25)
                , border3 (px 0) solid black
                , property "filter" "grayscale(80%)"
                ]
            , src imgSrc
            ]
            []
        ]


articleImage : String -> Html msg
articleImage imgSrc =
    div
        [ css
            [ width (pct 50), height (pct 100), float left ]
        ]
        [ img
            [ css
                [ width (pct 88)
                , margin4 (pct 4) zero (pct 2) (pct 6)
                , border3 (px 1) solid gray
                , property "filter" "grayscale(0%)"
                ]
            , src imgSrc
            ]
            []
        ]
