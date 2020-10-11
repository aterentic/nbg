module Components exposing (blue, footer, fullscreen, fullscreenButton, header, photo, white)

import Components.Photo exposing (View(..))
import Css exposing (Color, LengthOrAuto, Style, absolute, animationDelay, animationDuration, animationName, auto, backgroundColor, batch, block, border3, borderBottom3, borderTop3, bottom, calc, center, color, cursor, display, em, fixed, float, fontSize, fontWeight, height, hex, hidden, hover, int, left, letterSpacing, lighter, margin, margin2, margin4, marginTop, maxHeight, maxWidth, minus, num, opacity, overflow, padding, padding4, pct, pointer, position, property, px, relative, rgb, rgba, right, sec, solid, textAlign, top, vh, vw, width, zIndex, zero)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Transitions exposing (Transition, ease, transition)
import Html.Styled exposing (Html, div, h1, h2, h3, img, span, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)



-- Colors


setAlpha : Color -> Float -> Color
setAlpha color alpha =
    rgba color.red color.green color.blue alpha


white : Color
white =
    hex "#d6d6d6"


gray : Color
gray =
    rgb 127 127 127


blue : Color
blue =
    rgb 38 58 114


black : Color
black =
    rgb 0 0 0



-- Animations


fadeKeyframes : Float -> Float -> Keyframes {}
fadeKeyframes from to =
    keyframes
        [ ( 0, [ Css.Animations.opacity (num from) ] )
        , ( 100, [ Css.Animations.opacity (num to) ] )
        ]


fade : Float -> Float -> Float -> Float -> Style
fade from to duration delay =
    batch
        [ opacity (num from)
        , animationName <| fadeKeyframes from to
        , property "animation-fill-mode" "forwards"
        , animationDuration (sec duration)
        , animationDelay (sec delay)
        ]


fadeIn : Float -> Float -> Style
fadeIn duration delay =
    fade 0 100 duration delay


fadeOut : Float -> Float -> Style
fadeOut duration delay =
    fade 100 0 duration delay



-- Transitions


easeWidth : Float -> Float -> Transition
easeWidth duration delay =
    Css.Transitions.width3 duration delay ease


easeHeight : Float -> Float -> Transition
easeHeight duration delay =
    Css.Transitions.height3 duration delay ease


easeBottom : Float -> Float -> Transition
easeBottom duration delay =
    Css.Transitions.bottom3 duration delay ease


easeOpacity : Float -> Float -> Transition
easeOpacity duration delay =
    Css.Transitions.opacity3 duration delay ease


easeFilter : Float -> Float -> Transition
easeFilter duration delay =
    Css.Transitions.filter3 duration delay ease


easeMargin : Float -> Float -> Transition
easeMargin duration delay =
    Css.Transitions.margin3 duration delay ease


easeBorder : Float -> Float -> Transition
easeBorder duration delay =
    Css.Transitions.border3 duration delay ease


transitions : List (Float -> Float -> Transition) -> Float -> Float -> Style
transitions tfs duration delay =
    transition <| List.map (\f -> f duration delay) tfs



-- Positioning


topRight : LengthOrAuto a -> LengthOrAuto b -> Style
topRight topPos rightPos =
    batch [ position absolute, top topPos, right rightPos ]


topLeft : LengthOrAuto a -> LengthOrAuto b -> Style
topLeft topPos leftPos =
    batch [ position absolute, top topPos, left leftPos ]



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


photoHeadline : String -> Float -> Float -> Float -> msg -> Html msg
photoHeadline headline bottomPercent duration delay headlineClick =
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
            , transitions [ easeBottom ] duration delay
            , hover [ backgroundColor blue ]
            ]
        ]
        [ span [] [ Html.Styled.text headline ] ]



-- image ratio is 4:3


photoImage : View -> String -> Float -> Float -> Html msg
photoImage view image duration delay =
    case view of
        Article ->
            img
                [ css
                    [ width (pct 88)
                    , margin4 (pct 4) zero (pct 2) (pct 6)
                    , border3 (px 1) solid gray
                    , property "filter" "grayscale(0%)"
                    , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration delay
                    ]
                , src image
                ]
                []

        Teaser ->
            img
                [ css
                    [ width (pct 100)
                    , marginTop (pct -25)
                    , border3 (px 0) solid black
                    , property "filter" "grayscale(80%)"
                    , transitions [ easeBorder, easeFilter, easeMargin, easeWidth ] duration delay
                    ]
                , src image
                ]
                []


photo : View -> Photo -> msg -> msg -> Html msg
photo view { headline, text, image } headlineClick fullscreenClick =
    div
        [ css <|
            [ width (vw 100)
            , backgroundColor black
            , position relative
            ]
                ++ (case view of
                        Article ->
                            -- displaying whole image (reduced to 50%): (50/4)*3vw
                            [ height (vw 37.5), transitions [ easeHeight ] 500 0 ]

                        Teaser ->
                            -- displaying 25% of an image: (25/4)*3vw
                            [ height (vw 18.75), transitions [ easeHeight ] 500 500 ]
                   )
        ]
        [ div
            [ case view of
                Article ->
                    css
                        [ float right
                        , overflow hidden
                        , width (pct 50)
                        , opacity (num 100)
                        , height (pct 100)
                        , transition [ easeOpacity 500 500, easeWidth 500 0 ]
                        ]

                Teaser ->
                    css
                        [ float right
                        , overflow hidden
                        , width zero
                        , opacity zero
                        , height zero
                        , transition [ easeOpacity 500 0, easeWidth 500 500, easeHeight 500 500 ]
                        ]
            ]
            [ span
                [ css
                    [ padding4 (pct 4) (pct 8) zero zero
                    , display block
                    , color white
                    ]
                ]
                [ Html.Styled.text text ]
            ]
        , let
            duration =
                500

            delay =
                case view of
                    Article ->
                        0

                    Teaser ->
                        500
          in
          case view of
            Article ->
                div
                    -- calc(50vw / 4 * 3); Images ratio is 4:3, whole image is displayed
                    [ css
                        [ overflow hidden
                        , width (vw 50)
                        , height (vw 37.5)
                        , transitions [ easeHeight, easeWidth ] duration delay
                        ]
                    ]
                    [ photoImage Article image duration delay ]

            Teaser ->
                div
                    -- calc(100vw / 16 * 3); Images ratio is 4:3, 1/4 of image is displayed
                    [ css
                        [ overflow hidden
                        , width (pct 100)
                        , height (vw 18.75)
                        , transitions [ easeHeight, easeWidth ] duration delay
                        ]
                    ]
                    [ photoImage Teaser image duration delay ]
        , case view of
            Article ->
                photoHeadline headline 8 500 0 headlineClick

            Teaser ->
                photoHeadline headline 0 500 500 headlineClick
        , case view of
            Article ->
                fullscreenButton fullscreenClick [ fadeIn 0.5 0.5, topLeft (pct 10) (pct 5) ]

            Teaser ->
                fullscreenButton fullscreenClick [ fadeOut 0.5 0, topLeft (pct 10) (pct 5) ]
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
