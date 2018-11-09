module Palette.Helper exposing (black, contrastRatio, fontColor, footerColor, headerColor, largeFontSize, mediumFontSize, relativeLuminance, smallFontSize, threshold, white, xLargeFontSize, xSmallFontSize)

import Element exposing (..)
import Palette.Palette as Palette exposing (Palette)



-- LAYOUT


headerColor : Palette -> Color
headerColor palette =
    palette.midtoneColor


footerColor : Palette -> Color
footerColor palette =
    palette.shadowColor



-- FONT


xLargeFontSize : Palette -> Int
xLargeFontSize palette =
    round <| toFloat palette.fontSize * palette.fontRatio * 2


largeFontSize : Palette -> Int
largeFontSize palette =
    round <| toFloat palette.fontSize * palette.fontRatio


mediumFontSize : Palette -> Int
mediumFontSize palette =
    round <| toFloat palette.fontSize


smallFontSize : Palette -> Int
smallFontSize palette =
    round <| toFloat palette.fontSize / palette.fontRatio


xSmallFontSize : Palette -> Int
xSmallFontSize palette =
    round <| toFloat palette.fontSize / (palette.fontRatio * 2)



-- COLOR


white : Color
white =
    rgb 1 1 1


black : Color
black =
    rgb 0 0 0


fontColor : Color -> Color
fontColor backgroundColor =
    if contrastRatio backgroundColor white >= threshold then
        black

    else
        white


threshold : Float
threshold =
    10


{-| contrastRatio
<https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef>
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