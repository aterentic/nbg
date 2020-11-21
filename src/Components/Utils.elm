module Components.Utils exposing (black, blue, gray, setAlpha, topLeft, topRight, white, zeroMarginAndPadding)

import Css exposing (Color, LengthOrAuto, Style, absolute, batch, hex, left, margin, padding, position, rgb, rgba, right, top, zero)


zeroMarginAndPadding : Style
zeroMarginAndPadding =
    batch [ margin zero, padding zero ]



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



-- Positioning


topRight : LengthOrAuto a -> LengthOrAuto b -> Style
topRight topPos rightPos =
    batch [ position absolute, top topPos, right rightPos ]


topLeft : LengthOrAuto a -> LengthOrAuto b -> Style
topLeft topPos leftPos =
    batch [ position absolute, top topPos, left leftPos ]
