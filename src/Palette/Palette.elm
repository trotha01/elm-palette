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
    , fontRatio = 1.618

    -- Color
    , shadowColor = rgba 0 0 0 1
    , midtoneColor = rgba 0.2196078431372549 0.2235294117647059 0.8 1
    , highlightColor = rgba 0.6862745098039216 0.12549019607843137 0.7254901960784313 1
    , accentColor = rgba 0.7019607843137254 0.12941176470588237 0.12941176470588237 1

    -- Layout
    , headerHeight = px 200
    , footerHeight = px 100
    , padding = 18
    , spacing = 37
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
