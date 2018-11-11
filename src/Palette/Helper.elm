module Palette.Helper exposing (FontRatio, black, contrastRatio, fontColor, goldenRatio, largeFontSize, majorSixth, mediumFontSize, perfectFifth, perfectFourth, relativeLuminance, smallFontSize, threshold, white, xLargeFontSize, xSmallFontSize, xxLargeFontSize)

import Element exposing (..)
import Palette.Palette as Palette exposing (Palette)



-- FONT


xxLargeFontSize : Palette -> Int
xxLargeFontSize palette =
    round <| modular (toFloat palette.fontSize) palette.fontRatio 4


xLargeFontSize : Palette -> Int
xLargeFontSize palette =
    round <| modular (toFloat palette.fontSize) palette.fontRatio 3


largeFontSize : Palette -> Int
largeFontSize palette =
    round <| modular (toFloat palette.fontSize) palette.fontRatio 2


mediumFontSize : Palette -> Int
mediumFontSize palette =
    round <| modular (toFloat palette.fontSize) palette.fontRatio 1


smallFontSize : Palette -> Int
smallFontSize palette =
    round <| modular (toFloat palette.fontSize) palette.fontRatio -1


xSmallFontSize : Palette -> Int
xSmallFontSize palette =
    round <| modular (toFloat palette.fontSize) palette.fontRatio -2



-- ratios


type alias FontRatio =
    Float


perfectFifth : FontRatio
perfectFifth =
    1.5


perfectFourth : FontRatio
perfectFourth =
    1.333


goldenRatio : FontRatio
goldenRatio =
    1.618


majorSixth : FontRatio
majorSixth =
    1.667



-- COLOR


white : Color
white =
    rgb 1 1 1


black : Color
black =
    rgb 0 0 0


fontColor : Color -> Color
fontColor backgroundColor =
    if contrastRatio white backgroundColor >= threshold then
        white

    else
        black


threshold : Float
threshold =
    1.4


{-| contrastRatio
<https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef>

max contrast: 21
min contrast: 1

-}
contrastRatio : Color -> Color -> Float
contrastRatio color1 color2 =
    (relativeLuminance color1 + 0.05) / (relativeLuminance color2 + 0.05)


{-| relativeLuminance
<https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef>
-}
relativeLuminance : Color -> Float
relativeLuminance color =
    let
        { red, green, blue, alpha } =
            toRgb color
    in
    0.2126 * red + 0.7152 * green + 0.0722 * blue
