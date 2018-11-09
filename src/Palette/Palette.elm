module Palette.Palette exposing (FontRatio, Palette, default, goldenRatio, perfectFifth)

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
    }


default : Palette
default =
    { -- Font
      fontSize = 24
    , fontRatio = perfectFifth

    -- Color
    , shadowColor = rgb 0 0 0
    , midtoneColor = rgb 0.6 0.6 0.6
    , highlightColor = rgb 0.9 0.9 0.9
    , accentColor = rgb 0 0 0.8

    -- Layout
    , headerHeight = px 200
    , footerHeight = px 100
    , padding = 30
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
