module ExamplePalette exposing (palette)

import Element exposing (..)
import Palette exposing (FontRatio, Palette, goldenRatio, perfectFifth)


palette : Palette
palette =
    { -- Font
      fontSize = 17
    , fontRatio = perfectFifth

    -- Color
    , shadowColor = rgba 0 0 0 1
    , midtoneColor = rgba 0.3607843137254902 0.4666666666666667 0.8 1
    , highlightColor = rgba 0.596078431372549 0.34509803921568627 0.7254901960784313 1
    , accentColor = rgba 0.7019607843137254 0.12941176470588237 0.12941176470588237 1

    -- Layout
    , headerHeight = px 200
    , footerHeight = px 100
    , padding = 14
    , spacing = 31
    }
