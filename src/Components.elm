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
    el [ height fill ] e


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


card : Palette -> Element msg
card palette =
    column
        [ width (px 200)
        , height (px 300)
        ]
        [ el
            [ height (fillPortion 1 |> minimum 50)
            , width fill
            , padding palette.padding
            , Background.color (Palette.headerColor palette)
            , Font.size (Palette.largeFontSize palette)
            , Font.color (Palette.fontColor (Palette.headerColor palette))
            ]
            (text "modal header")
        , el
            [ height (fillPortion 4 |> minimum 100)
            , width fill
            ]
            (text "modal content")
        ]
