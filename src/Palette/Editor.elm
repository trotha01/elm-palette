module Palette.Editor exposing (Msg(..), PaletteEditor, Position, accentColor, black, codeFromPaletteEditor, decodeMouseMove, fromEditor, init, mousePositionDecoder, paletteCode, subscriptions, update, view, viewFontSizeSelector, viewHeader, viewSaveButton, viewSelectors, white)

import Browser.Events as Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onMouseDown, onMouseUp)
import Element.Font as Font
import Element.Input as Input
import Json.Decode as Decode exposing (Decoder)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Palette.Helper as Helper
import Palette.Palette as Palette exposing (Palette)
import Url



-- MODEL


type alias PaletteEditor =
    { position : Position
    , dragging : Bool
    , fontSize : Int
    }


type alias Position =
    Vec2


init : PaletteEditor
init =
    { position = vec2 0 0
    , dragging = False
    , fontSize = 24
    }


fromEditor : PaletteEditor -> Palette
fromEditor paletteEditor =
    { -- Font
      fontSize = paletteEditor.fontSize
    , fontRatio = Palette.perfectFifth

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



-- UPDATE


type Msg
    = MouseDown
    | MouseMove Position
    | MouseUp
    | FontSize Int
    | Save


update : Msg -> PaletteEditor -> PaletteEditor
update msg model =
    case msg of
        MouseDown ->
            { model | dragging = True }

        MouseUp ->
            { model | dragging = False }

        MouseMove position ->
            { model | position = position }

        FontSize fontSize ->
            { model | fontSize = fontSize }

        Save ->
            model



-- VIEW


view : PaletteEditor -> Element Msg
view paletteEditor =
    el
        [ width (px 300)
        , height (px 400)
        , moveRight (Vec2.getX paletteEditor.position)
        , moveDown (Vec2.getY paletteEditor.position)
        , scrollbarY
        , Border.color black
        , Border.glow black 2
        , Background.color white
        ]
        (column []
            [ viewHeader
            , viewSelectors paletteEditor
            ]
        )


viewHeader : Element Msg
viewHeader =
    el
        [ width (px 300)
        , height (px 50)
        , Background.color black
        , Font.color white

        -- Event Listeners
        , onMouseDown MouseDown
        , onMouseUp MouseUp
        ]
        (text "Palette")


viewSelectors : PaletteEditor -> Element Msg
viewSelectors paletteEditor =
    column [ width fill, padding 10, spacing 10 ]
        [ viewFontSizeSelector paletteEditor
        , viewSaveButton paletteEditor
        ]


viewSaveButton : PaletteEditor -> Element Msg
viewSaveButton paletteEditor =
    downloadAs
        [ alignBottom
        , Background.color accentColor
        , Font.color (Helper.fontColor accentColor)
        , Border.rounded 2
        , padding 10
        ]
        { label = el [] (text "Save")
        , filename = "Palette.elm"
        , url = "data:text/plain;charset=utf-8," ++ Url.percentEncode (codeFromPaletteEditor paletteEditor)
        }


viewFontSizeSelector : PaletteEditor -> Element Msg
viewFontSizeSelector paletteEditor =
    let
        currentFontSize =
            paletteEditor.fontSize

        label =
            "Font Size: " ++ String.fromInt currentFontSize
    in
    Input.slider
        [ height (px 5)
        , width fill
        , padding 10
        , centerY
        , Background.color (rgb 0.5 0.5 0.5)
        , Border.rounded 2
        ]
        { onChange = round >> FontSize
        , label = Input.labelAbove [] (el [] (text label))
        , min = 1
        , max = 100
        , value = toFloat currentFontSize
        , thumb = Input.defaultThumb
        , step = Just 1
        }


black =
    rgb 0 0 0


white =
    rgb 1 1 1


accentColor =
    rgb 0 0 0.8



-- SUBSCRIPTIONS


subscriptions : PaletteEditor -> Sub Msg
subscriptions model =
    if model.dragging then
        Sub.batch [ Events.onMouseMove decodeMouseMove ]

    else
        Sub.none


decodeMouseMove : Decoder Msg
decodeMouseMove =
    Decode.map MouseMove mousePositionDecoder


mousePositionDecoder : Decode.Decoder Position
mousePositionDecoder =
    Decode.map2 vec2
        (Decode.field "pageX" Decode.float)
        (Decode.field "pageY" Decode.float)



--  PALETTE FILE CREATOR


codeFromPaletteEditor : PaletteEditor -> String
codeFromPaletteEditor paletteEditor =
    paletteCode
        |> String.replace "<FONT_SIZE>" (String.fromInt paletteEditor.fontSize)


paletteCode =
    """module Palette.Palette exposing (..)

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
      fontSize = <FONT_SIZE>
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
"""
