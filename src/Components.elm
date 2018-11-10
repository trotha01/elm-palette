module Components exposing (card, content, footer, header)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Palette.Helper as Palette
import Palette.Palette as Palette exposing (Palette)


header : Palette -> Element msg -> Element msg
header palette e =
    el
        [ height palette.headerHeight
        , width fill
        , padding palette.padding
        , Background.color (Palette.headerColor palette)
        , Font.size (Palette.xLargeFontSize palette)
        , Font.color (Palette.fontColor (Palette.headerColor palette))
        ]
        e


content : Palette -> Element msg -> Element msg
content palette e =
    el [ height fill, width fill ] e


footer : Palette -> Element msg -> Element msg
footer palette e =
    el
        [ height palette.footerHeight
        , width fill
        , padding palette.padding
        , Background.color (Palette.footerColor palette)
        , Font.size (Palette.smallFontSize palette)
        , Font.color (Palette.fontColor (Palette.footerColor palette))
        ]
        e


card : Palette -> Element msg -> Element msg
card palette contents =
    el
        [ height (px 100)
        , width fill -- (fillPortion 3)
        , padding palette.padding
        , Background.color (Palette.headerColor palette)
        , Font.size (Palette.largeFontSize palette)
        , Font.color (Palette.fontColor (Palette.headerColor palette))
        ]
        contents
