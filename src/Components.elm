module Components exposing (PhotoView(..), blue, footer, fullscreen, fullscreenButton, header, photo, white)

import Css exposing (Color, FontSize, LengthOrAuto, Style, absolute, animationDelay, animationDuration, animationName, auto, backgroundColor, batch, block, border3, borderBottom3, borderTop3, bottom, calc, center, color, cursor, display, em, fixed, float, fontSize, fontWeight, height, hex, hidden, hover, int, left, letterSpacing, lighter, margin, margin2, margin4, marginTop, maxHeight, maxWidth, minus, num, opacity, overflow, padding, padding4, pct, pointer, position, property, px, relative, rgb, rgba, right, sec, solid, textAlign, top, vh, vw, width, zIndex, zero)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Transitions exposing (ease, transition)
import Html.Styled exposing (Html, div, h1, h2, h3, img, span, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)


setAlpha : Color -> Float -> Color
setAlpha color alpha =
    rgba color.red color.green color.blue alpha


white : Color
white =
    hex "#d6d6d6"


gray : Color
gray =
    rgb 127 127 127


black : Color
black =
    rgb 0 0 0


blue : Color
blue =
    rgb 38 58 114


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


type PhotoView
    = Article
    | Teaser


type alias Photo =
    { headline : String
    , text : String
    , image : String
    }


photoHeadline : String -> Float -> Float -> msg -> Html msg
photoHeadline headline bottomPercent delay headlineClick =
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
            , transition [ Css.Transitions.bottom3 500 delay Css.Transitions.ease ]
            , hover [ backgroundColor blue ]
            ]
        ]
        [ span [] [ Html.Styled.text headline ] ]


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


topRight : LengthOrAuto a -> LengthOrAuto b -> Style
topRight topPos rightPos =
    batch [ position absolute, top topPos, right rightPos ]


topLeft : LengthOrAuto a -> LengthOrAuto b -> Style
topLeft topPos leftPos =
    batch [ position absolute, top topPos, left leftPos ]



-- image ratio is 4:3


photo : PhotoView -> Photo -> msg -> msg -> Html msg
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
                            [ height (vw 37.5)
                            , transition [ Css.Transitions.height3 500 0 ease ]
                            ]

                        Teaser ->
                            -- displaying 25% of an image: (25/4)*3vw
                            [ height (vw 18.75)
                            , transition [ Css.Transitions.height3 500 500 ease ]
                            ]
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
                        , transition
                            [ Css.Transitions.opacity3 500 500 ease
                            , Css.Transitions.width3 500 0 ease
                            ]
                        ]

                Teaser ->
                    css
                        [ float right
                        , overflow hidden
                        , width zero
                        , opacity zero
                        , height zero
                        , transition
                            [ Css.Transitions.opacity3 500 0 ease
                            , Css.Transitions.width3 500 500 ease
                            , Css.Transitions.height3 500 500 ease
                            ]
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
        , case view of
            Article ->
                div
                    -- calc(50vw / 4 * 3); Images ratio is 4:3, whole image is displayed
                    [ css
                        [ overflow hidden
                        , width (vw 50)
                        , height (vw 37.5)
                        , transition
                            [ Css.Transitions.height3 500 0 ease
                            , Css.Transitions.width3 500 0 ease
                            ]
                        ]
                    ]
                    [ img
                        [ css
                            [ width (pct 88)
                            , margin4 (pct 4) zero (pct 2) (pct 6)
                            , border3 (px 1) solid gray
                            , property "filter" "grayscale(0%)"
                            , transition
                                [ Css.Transitions.border3 500 0 ease
                                , Css.Transitions.filter3 500 0 ease
                                , Css.Transitions.margin3 500 0 ease
                                , Css.Transitions.width3 500 0 ease
                                ]
                            ]
                        , src image
                        ]
                        []
                    ]

            Teaser ->
                div
                    -- calc(100vw / 16 * 3); Images ratio is 4:3, 1/4 of image is displayed
                    [ css
                        [ overflow hidden
                        , width (pct 100)
                        , height (vw 18.75)
                        , transition
                            [ Css.Transitions.height3 500 500 ease
                            , Css.Transitions.width3 500 500 ease
                            ]
                        ]
                    ]
                    [ img
                        [ css
                            [ width (pct 100)
                            , marginTop (pct -25)
                            , border3 (px 0) solid black
                            , property "filter" "grayscale(80%)"
                            , transition
                                [ Css.Transitions.border3 500 500 ease
                                , Css.Transitions.filter3 500 500 ease
                                , Css.Transitions.margin3 500 500 ease
                                , Css.Transitions.width3 500 500 ease
                                ]
                            ]
                        , src image
                        ]
                        []
                    ]
        , case view of
            Article ->
                photoHeadline headline 8 0 headlineClick

            Teaser ->
                photoHeadline headline 0 500 headlineClick
        , case view of
            Article ->
                fullscreenButton fullscreenClick [ fadeIn 0.5 0.5, topLeft (pct 10) (pct 5) ]

            Teaser ->
                fullscreenButton fullscreenClick [ fadeOut 0.5 0, topLeft (pct 10) (pct 5) ]
        ]


zeroMarginAndPadding : Style
zeroMarginAndPadding =
    batch [ margin zero, padding zero ]


defaultH : FontSize a -> Style
defaultH fs =
    batch [ zeroMarginAndPadding, fontSize fs, color white ]


header : String -> String -> Html msg
header headline description =
    Html.Styled.header
        [ css
            [ padding4 (em 1.5) zero (em 1.5) (pct 5)
            , borderBottom3 (px 1) solid white
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
    div [ css [ borderTop3 (px 1) solid white ] ] []


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
