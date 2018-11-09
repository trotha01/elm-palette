module StyledUI.Element exposing (Attribute, Element, Length, column, el, fill, height, layout, padding, row, spacing, text, width)

import Element as El
import Html exposing (Html)
import Palette


type alias Element msg =
    El.Element msg


type alias Attribute msg =
    El.Attribute msg


type alias Length =
    El.Length


layout : List (Attribute msg) -> Element msg -> Html msg
layout =
    El.layout


el : List (Attribute msg) -> Element msg -> Element msg
el =
    El.el


text : String -> Element msg
text =
    El.text


width : Length -> Attribute msg
width =
    El.width


height : Length -> Attribute msg
height =
    El.height


fill : Length
fill =
    El.fill


spacing : Int -> Attribute msg
spacing =
    El.spacing


padding : Int -> Attribute msg
padding =
    El.padding


column : List (El.Attribute msg) -> List (El.Element msg) -> El.Element msg
column attrs children =
    El.column ([ El.width El.fill, El.spacing Palette.defaultSpacing ] ++ attrs) children


row : List (El.Attribute msg) -> List (El.Element msg) -> El.Element msg
row attrs children =
    El.row ([ El.width El.fill, El.spacing Palette.defaultSpacing ] ++ attrs) children
