module Utils exposing (black, blue, easeBorder, easeBottom, easeFilter, easeHeight, easeMargin, easeOpacity, easeWidth, gray, setAlpha, transitions, white)

import Css exposing (Color, Style, hex, rgb, rgba)
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
