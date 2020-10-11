module Components.Photo exposing (View(..), container, headline, text)

import Css exposing (absolute, backgroundColor, block, border3, bottom, color, cursor, display, em, float, fontSize, height, hidden, hover, margin4, marginTop, num, opacity, overflow, padding, padding4, pct, pointer, position, property, px, right, solid, vw, width, zero)
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, h2, img, span)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import Utils exposing (black, blue, easeBorder, easeBottom, easeFilter, easeHeight, easeMargin, easeOpacity, easeWidth, gray, setAlpha, transitions, white)


type View
    = Article
    | Teaser


text : View -> String -> Float -> Float -> Html msg
text view articleText duration delay =
    div
        [ case view of
            Article ->
                css
                    [ float right
                    , overflow hidden
                    , width (pct 50)
                    , opacity (num 100)
                    , height (pct 100)
                    , transition [ easeOpacity duration delay, easeWidth duration 0 ]
                    ]

            Teaser ->
                css
                    [ float right
                    , overflow hidden
                    , width zero
                    , opacity zero
                    , height zero
                    , transition [ easeOpacity duration 0, easeWidth duration delay, easeHeight duration delay ]
                    ]
        ]
        [ span
            [ css
                [ padding4 (pct 4) (pct 8) zero zero
                , display block
                , color white
                ]
            ]
            [ Html.Styled.text articleText ]
        ]


headline : View -> String -> Float -> Float -> msg -> Html msg
headline view headlineText duration delay headlineClick =
    let
        ( bottomPercent, transitionDelay ) =
            case view of
                Article ->
                    ( 8, 0 )

                Teaser ->
                    ( 0, delay )
    in
    h2
        [ onClick headlineClick
        , css <|
            [ fontSize (em 1.5)
            , color white
            , backgroundColor <| setAlpha blue 0.75
            , padding (em 0.5)
            , cursor pointer
            , margin4 zero zero (em 1) (pct 5)
            , position absolute
            , bottom (pct bottomPercent)
            , transitions [ easeBottom ] duration transitionDelay
            , hover [ backgroundColor blue ]
            ]
        ]
        [ span [] [ Html.Styled.text headlineText ] ]


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
