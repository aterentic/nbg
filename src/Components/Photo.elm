module Components.Photo exposing (View(..), image)

import Css exposing (border3, margin4, marginTop, pct, property, px, solid, width, zero)
import Html.Styled exposing (Html, img)
import Html.Styled.Attributes exposing (css, src)
import Utils exposing (black, easeBorder, easeFilter, easeMargin, easeWidth, gray, transitions)


type View
    = Article
    | Teaser


image : View -> String -> Float -> Float -> Html msg
image view imgSrc duration delay =
    let
        style =
            case view of
                Article ->
                    [ width (pct 88)
                    , margin4 (pct 4) zero (pct 2) (pct 6)
                    , border3 (px 1) solid gray
                    , property "filter" "grayscale(0%)"
                    , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration delay
                    ]

                Teaser ->
                    [ width (pct 100)
                    , marginTop (pct -25)
                    , border3 (px 0) solid black
                    , property "filter" "grayscale(80%)"
                    , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration delay
                    ]
    in
    img [ css style, src imgSrc ] []
