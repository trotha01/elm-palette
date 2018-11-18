module StyledUI.Input exposing (button)

import Element as El exposing (..)
import Element.Background as Background
import Element.Input as El exposing (..)
import Palette exposing (..)


button : { onPress : Maybe msg, label : Element msg } -> Element msg
button { onPress, label } =
    El.el []
        (El.button
            [ width (px 200)
            , height (px 60)
            , padding 10
            , Background.color Palette.accentColor
            ]
            { onPress = onPress, label = label }
        )
