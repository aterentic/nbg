module Components.Photo exposing (View(..), container)

import Css exposing (border3, height, hidden, margin4, marginTop, overflow, pct, property, px, solid, vw, width, zero)
import Html.Styled exposing (Html, div, img)
import Html.Styled.Attributes exposing (css, src)
import Utils exposing (black, easeBorder, easeFilter, easeHeight, easeMargin, easeWidth, gray, transitions)


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
                    , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration 0
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


container : View -> String -> Float -> Float -> Html msg
container view imgSrc duration delay =
    let
        style =
            case view of
                -- calc(50vw / 4 * 3); Images ratio is 4:3, whole image is displayed
                Article ->
                    [ overflow hidden
                    , width (vw 50)
                    , height (vw 37.5)
                    , transitions [ easeHeight, easeWidth ] duration 0
                    ]

                -- calc(100vw / 16 * 3); Images ratio is 4:3, 1/4 of image is displayed
                Teaser ->
                    [ overflow hidden
                    , width (pct 100)
                    , height (vw 18.75)
                    , transitions [ easeHeight, easeWidth ] duration delay
                    ]
    in
    div [ css style ] [ image view imgSrc duration delay ]
