module Palette.Palette exposing (..)

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
    , midtoneColor = rgba 0.45098039215686275 0.5019607843137255 0.8 1
    , highlightColor = rgba 0.6745098039215687 0.6 0.8509803921568627 1
    , accentColor = rgba 0.7019607843137254 0.12941176470588237 0.12941176470588237 1

    -- Layout
    , headerHeight = px 200
    , footerHeight = px 100
    , padding = 15
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
