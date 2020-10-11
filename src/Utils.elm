module Utils exposing (black, blue, easeBorder, easeBottom, easeFilter, easeHeight, easeMargin, easeOpacity, easeWidth, fadeIn, fadeOut, gray, setAlpha, topLeft, topRight, transitions, white)

import Css exposing (Color, LengthOrAuto, Style, absolute, animationDelay, animationDuration, animationName, batch, hex, left, num, opacity, position, property, rgb, rgba, right, sec, top)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Transitions exposing (Transition, ease, transition)



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
        , animationDuration (sec <| duration / 1000)
        , animationDelay (sec <| delay / 1000)
        ]


fadeIn : Float -> Float -> Style
fadeIn duration delay =
    fade 0 100 duration delay


fadeOut : Float -> Float -> Style
fadeOut duration delay =
    fade 100 0 duration delay



-- Positioning


topRight : LengthOrAuto a -> LengthOrAuto b -> Style
topRight topPos rightPos =
    batch [ position absolute, top topPos, right rightPos ]


topLeft : LengthOrAuto a -> LengthOrAuto b -> Style
topLeft topPos leftPos =
    batch [ position absolute, top topPos, left leftPos ]
