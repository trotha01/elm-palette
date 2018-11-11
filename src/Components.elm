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
        , Background.color palette.highlightColor
        , Font.size (Palette.xLargeFontSize palette)
        , Font.color (Palette.fontColor palette.highlightColor)
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
        , Background.color palette.shadowColor
        , Font.size (Palette.smallFontSize palette)
        , Font.color (Palette.fontColor palette.shadowColor)
        ]
        e


card : Palette -> Element msg -> Element msg
card palette contents =
    el
        [ height (px 100)
        , width fill
        , padding palette.padding
        , Background.color palette.midtoneColor
        , Font.size <| Palette.largeFontSize palette
        , Font.color <| Palette.fontColor palette.midtoneColor
        ]
        contents
