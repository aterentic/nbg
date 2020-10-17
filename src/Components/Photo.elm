module Components.Photo exposing (article, teaser)

import Components.Common exposing (blueButton, fullscreenIcon)
import Components.Utils exposing (black, blue, easeBorder, easeBottom, easeFilter, easeHeight, easeMargin, easeOpacity, easeWidth, fadeIn, fadeOut, gray, setAlpha, topLeft, transitions, white)
import Css exposing (Style, absolute, backgroundColor, block, border3, bottom, color, cursor, display, em, float, fontSize, fontWeight, height, hidden, hover, lighter, margin4, marginTop, num, opacity, overflow, padding, padding4, pct, pointer, position, property, px, relative, right, solid, vw, width, zero)
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, h2, img, span, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)


articleStyle : Float -> List Style
articleStyle duration =
    [ width (pct 50)
    , opacity (num 100)
    , height (pct 100)
    , transition [ easeOpacity duration duration, easeWidth duration 0 ]
    ]


teaserStyle : Float -> List Style
teaserStyle duration =
    [ width zero
    , opacity zero
    , height zero
    , transition [ easeOpacity duration 0, easeWidth duration duration, easeHeight duration duration ]
    ]


photoText : List Style -> String -> Html msg
photoText styles value =
    div
        [ css <| [ float right, overflow hidden ] ++ styles ]
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


photoHeadline : Float -> Float -> String -> Float -> msg -> Html msg
photoHeadline bottomPercent transitionDelay headlineText duration headlineClick =
    h2
        [ onClick headlineClick
        , css <|
            [ fontSize (em 1.75)
            , fontWeight lighter
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


articleImage : String -> Float -> Html msg
articleImage imgSrc duration =
    -- calc(50vw / 4 * 3); Images ratio is 4:3, whole image is displayed
    div
        [ css
            [ overflow hidden
            , width (vw 50)
            , height (vw 37.5)
            , transitions [ easeHeight, easeWidth ] duration 0
            ]
        ]
        [ img
            [ css
                [ width (pct 88)
                , margin4 (pct 4) zero (pct 2) (pct 6)
                , border3 (px 1) solid gray
                , property "filter" "grayscale(0%)"
                , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration 0
                ]
            , src imgSrc
            ]
            []
        ]


teaserImage : String -> Float -> Html msg
teaserImage imgSrc duration =
    -- calc(100vw / 16 * 3); Images ratio is 4:3, 1/4 of image is displayed
    div
        [ css
            [ overflow hidden
            , width (pct 100)
            , height (vw 18.75)
            , transitions [ easeHeight, easeWidth ] duration duration
            ]
        ]
        [ img
            [ css
                [ width (pct 100)
                , marginTop (pct -25)
                , border3 (px 0) solid black
                , property "filter" "grayscale(80%)"
                , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration duration
                ]
            , src imgSrc
            ]
            []
        ]



-- image ratio is 4:3


article : Float -> { a | headline : String, text : String, image : String } -> msg -> msg -> Html msg
article duration { headline, text, image } headlineClick fullscreenClick =
    div
        [ css <|
            [ width (vw 100)
            , backgroundColor black
            , position relative

            -- displaying whole image (reduced to 50%): (50/4)*3vw
            , height (vw 37.5)
            , transitions [ easeHeight ] duration 0
            ]
        ]
        [ photoText (articleStyle duration) text
        , articleImage image duration
        , photoHeadline 8 0 headline duration headlineClick
        , blueButton
            [ onClick fullscreenClick
            , css [ fadeIn duration duration, topLeft (pct 10) (pct 5) ]
            ]
            [ fullscreenIcon ]
        ]


teaser : Float -> { a | headline : String, text : String, image : String } -> msg -> msg -> Html msg
teaser duration { headline, text, image } headlineClick fullscreenClick =
    div
        [ css <|
            [ width (vw 100)
            , backgroundColor black
            , position relative

            -- displaying 25% of an image: (25/4)*3vw
            , height (vw 18.75)
            , transitions [ easeHeight ] duration duration
            ]
        ]
        [ photoText (teaserStyle duration) text
        , teaserImage image duration
        , photoHeadline 0 duration headline duration headlineClick
        , blueButton
            [ onClick fullscreenClick
            , css [ fadeOut duration 0, topLeft (pct 10) (pct 5) ]
            ]
            [ fullscreenIcon ]
        ]
