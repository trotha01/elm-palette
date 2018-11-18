module Palette exposing (FontRatio, Palette, default, goldenRatio, perfectFifth)

import Element exposing (..)


type alias Palette =
    { -- Font
      fontSize : Int
    , fontRatio : FontRatio

    -- Color
    , shadowColor : Color
    , midtoneColor : Color
    , highlightColor : Color
    , accentColor : Color

    -- Layout
    , headerHeight : Length
    , footerHeight : Length
    , padding : Int
    , spacing : Int
    }


default : Palette
default =
    { -- Font
      fontSize = 17
    , fontRatio = 1.5

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



-- ratios


type alias FontRatio =
    Float


perfectFifth : FontRatio
perfectFifth =
    1.5


goldenRatio : FontRatio
goldenRatio =
    1.618
