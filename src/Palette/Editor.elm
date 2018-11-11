module Palette.Editor exposing (Msg(..), PaletteEditor, Position, black, codeFromPaletteEditor, decodeMouseMove, fontRatioOptions, fromEditor, init, mousePositionDecoder, paletteCode, subscriptions, update, view, viewExpanded, viewFontRatioSelector, viewFontSizeSelector, viewHeader, viewMinimizeButton, viewMinimized, viewPaddingSelector, viewRadio, viewSaveButton, viewSelectors, viewSlider, viewSpacingSelector, white)

import Browser.Events as Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick, onMouseDown, onMouseUp)
import Element.Font as Font
import Element.Input as Input
import Hex
import Html
import Html.Attributes as Attr
import Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Decoder)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Palette.Helper as Helper
import Palette.Palette as Palette exposing (Palette)
import Result
import String
import Url



-- MODEL


type alias PaletteEditor =
    { position : Position
    , dragging : Bool
    , minimized : Bool

    -- Palette Options
    , fontSize : Int
    , fontRatio : Helper.FontRatio
    , padding : Int
    , spacing : Int

    -- color
    , shadowColor : Color
    , midtoneColor : Color
    , highlightColor : Color
    , accentColor : Color
    }


type alias Position =
    Vec2


init : Palette -> PaletteEditor
init palette =
    { position = vec2 0 0
    , dragging = False
    , minimized = True

    -- Palette Options
    , fontSize = palette.fontSize
    , fontRatio = palette.fontRatio
    , padding = palette.padding
    , spacing = palette.spacing

    -- color
    , shadowColor = palette.shadowColor
    , midtoneColor = palette.midtoneColor
    , highlightColor = palette.highlightColor
    , accentColor = palette.accentColor
    }


fromEditor : PaletteEditor -> Palette
fromEditor paletteEditor =
    { -- Font
      fontSize = paletteEditor.fontSize
    , fontRatio = paletteEditor.fontRatio

    -- Color
    , shadowColor = paletteEditor.shadowColor
    , midtoneColor = paletteEditor.midtoneColor
    , highlightColor = paletteEditor.highlightColor
    , accentColor = paletteEditor.accentColor

    -- Layout
    , headerHeight = px 200
    , footerHeight = px 100
    , padding = paletteEditor.padding
    , spacing = paletteEditor.spacing
    }



-- UPDATE


type Msg
    = MouseDown
    | MouseMove Position
    | MouseUp
    | Minimize
    | Maximize
    | Save
      -- Palette Updates
    | FontSize Int
    | FontRatio Float
    | Padding Int
    | Spacing Int
      -- color
    | ShadowColor Color
    | MidtoneColor Color
    | HighlightColor Color
    | AccentColor Color


update : Msg -> PaletteEditor -> PaletteEditor
update msg model =
    case msg of
        MouseDown ->
            { model | dragging = True }

        MouseUp ->
            { model | dragging = False }

        MouseMove position ->
            { model | position = position }

        Minimize ->
            { model | minimized = True }

        Maximize ->
            { model | minimized = False }

        Save ->
            model

        -- Palette Updates
        FontSize fontSize ->
            { model | fontSize = fontSize }

        FontRatio fontRatio ->
            { model | fontRatio = fontRatio }

        Padding padding ->
            { model | padding = padding }

        Spacing spacing ->
            { model | spacing = spacing }

        -- color
        ShadowColor shadowColor ->
            { model | shadowColor = shadowColor }

        MidtoneColor midtoneColor ->
            { model | midtoneColor = midtoneColor }

        HighlightColor highlightColor ->
            { model | highlightColor = highlightColor }

        AccentColor accentColor ->
            { model | accentColor = accentColor }



-- VIEW


view : PaletteEditor -> Element Msg
view paletteEditor =
    if paletteEditor.minimized then
        viewMinimized paletteEditor

    else
        viewExpanded paletteEditor


viewMinimized : PaletteEditor -> Element Msg
viewMinimized paletteEditor =
    el
        [ width (px 300)
        , alignBottom
        , Border.color white
        , onClick Maximize
        , Background.color (rgba 1 1 1 0.7)
        ]
        (viewHeader paletteEditor)


viewExpanded : PaletteEditor -> Element Msg
viewExpanded paletteEditor =
    el
        [ width (px 300)
        , height (px 400)
        , moveRight (Vec2.getX paletteEditor.position)
        , moveDown (Vec2.getY paletteEditor.position)
        , scrollbarY
        , Border.color black
        , Border.shadow { offset = ( 2, 2 ), size = 1, blur = 2, color = rgb 0 0 0 }
        , Background.color (rgba 1 1 1 0.7)
        , clip
        ]
        (column [ height (px 400) ]
            [ viewHeader paletteEditor
            , viewSelectors paletteEditor
            ]
        )


viewHeader : PaletteEditor -> Element Msg
viewHeader paletteEditor =
    let
        ( contents, cursor ) =
            if paletteEditor.minimized then
                ( [ el [] (text "Palette") ]
                , pointer
                )

            else
                ( [ el [] (text "Palette"), viewMinimizeButton ]
                , htmlAttribute (Attr.style "cursor" "move")
                )
    in
    row
        [ width (px 300)
        , height (px 30)
        , Background.color (rgba 0 0 0 0.7)
        , Font.color white
        , cursor

        -- Event Listeners
        , onMouseDown MouseDown
        , onMouseUp MouseUp
        ]
        contents


viewMinimizeButton : Element Msg
viewMinimizeButton =
    el
        [ alignRight
        , width (px 30)
        , onClick Minimize
        , pointer
        ]
        (text "-")


viewSelectors : PaletteEditor -> Element Msg
viewSelectors paletteEditor =
    column [ width fill, height fill, padding 10, spacing 20, scrollbars ]
        [ -- font
          viewFontSizeSelector paletteEditor
        , viewFontRatioSelector paletteEditor

        -- layout
        , viewPaddingSelector paletteEditor
        , viewSpacingSelector paletteEditor

        -- colors
        , row [] [ text "Color Scheme" ]
        , viewShadowColorSelector paletteEditor
        , viewMidtoneColorSelector paletteEditor
        , viewHighlightColorSelector paletteEditor
        , viewAccentColorSelector paletteEditor

        -- save
        , viewSaveButton paletteEditor
        ]


viewSaveButton : PaletteEditor -> Element Msg
viewSaveButton paletteEditor =
    downloadAs
        [ alignBottom
        , Background.color (rgba 0 0 0.5 0.8)
        , Font.color (Helper.fontColor (rgba 0 0 0.5 0.8))
        , Border.rounded 2
        , padding 10
        ]
        { label = el [] (text "Save")
        , filename = "Palette.elm"
        , url = "data:text/plain;charset=utf-8," ++ Url.percentEncode (codeFromPaletteEditor paletteEditor)
        }


viewPaddingSelector : PaletteEditor -> Element Msg
viewPaddingSelector paletteEditor =
    let
        value =
            toFloat paletteEditor.padding

        label =
            "Padding: " ++ String.fromInt paletteEditor.padding
    in
    viewSlider paletteEditor (round >> Padding) label value


viewSpacingSelector : PaletteEditor -> Element Msg
viewSpacingSelector paletteEditor =
    let
        value =
            toFloat paletteEditor.spacing

        label =
            "Spacing: " ++ String.fromInt paletteEditor.spacing
    in
    viewSlider paletteEditor (round >> Spacing) label value


viewFontSizeSelector : PaletteEditor -> Element Msg
viewFontSizeSelector paletteEditor =
    let
        value =
            toFloat paletteEditor.fontSize

        label =
            "Font Size: " ++ String.fromInt paletteEditor.fontSize
    in
    viewSlider paletteEditor (round >> FontSize) label value


viewFontRatioSelector : PaletteEditor -> Element Msg
viewFontRatioSelector paletteEditor =
    viewRadio paletteEditor FontRatio fontRatioOptions (Just paletteEditor.fontRatio) "Font Ratio:"


fontRatioOptions : List (Input.Option Float msg)
fontRatioOptions =
    [ Input.option 1.333 (el [ width (px 50) ] (text "Perfect Fourth (3:4)"))
    , Input.option 1.5 (el [ width (px 50) ] (text "Perfect Fifth (2:3)"))
    , Input.option 1.618 (el [ width (px 50) ] (text "Golden Ratio (1:1.618)"))
    , Input.option 1.667 (el [ width (px 50) ] (text "Major Sixth (3:5)"))
    ]


viewShadowColorSelector : PaletteEditor -> Element Msg
viewShadowColorSelector paletteEditor =
    viewColorSelector paletteEditor ShadowColor "Shadow: " paletteEditor.shadowColor


viewMidtoneColorSelector : PaletteEditor -> Element Msg
viewMidtoneColorSelector paletteEditor =
    viewColorSelector paletteEditor MidtoneColor "Midtone: " paletteEditor.midtoneColor


viewHighlightColorSelector : PaletteEditor -> Element Msg
viewHighlightColorSelector paletteEditor =
    viewColorSelector paletteEditor HighlightColor "Highlight: " paletteEditor.highlightColor


viewAccentColorSelector : PaletteEditor -> Element Msg
viewAccentColorSelector paletteEditor =
    viewColorSelector paletteEditor AccentColor "Accent: " paletteEditor.accentColor


viewColorSelector : PaletteEditor -> (Color -> Msg) -> String -> Color -> Element Msg
viewColorSelector paletteEditor onChange label currentColor =
    let
        currentRgb =
            toRgb currentColor
    in
    row []
        [ text label
        , Element.html <|
            Html.input
                [ Attr.type_ "color"
                , Attr.value (colorToHex currentColor)
                , onInput (colorFromHex >> Maybe.withDefault currentColor >> onChange)
                ]
                []
        ]


colorFromHex : String -> Maybe Color
colorFromHex hex =
    if String.length hex /= 7 then
        Nothing

    else
        Maybe.map3 (\r g b -> rgb255 r g b)
            (String.slice 1 3 hex |> Hex.fromString |> Result.toMaybe)
            (String.slice 3 5 hex |> Hex.fromString |> Result.toMaybe)
            (String.slice 5 7 hex |> Hex.fromString |> Result.toMaybe)


colorToHex : Color -> String
colorToHex color =
    let
        colorRgb =
            toRgb color
    in
    "#"
        ++ (fixHex <| Hex.toString <| round <| colorRgb.red * 255)
        ++ (fixHex <| Hex.toString <| round <| colorRgb.green * 255)
        ++ (fixHex <| Hex.toString <| round <| colorRgb.blue * 255)


colorToCode : Color -> String
colorToCode color =
    color
        |> toRgb
        |> (\colorRgb ->
                "rgba "
                    ++ String.fromFloat colorRgb.red
                    ++ " "
                    ++ String.fromFloat colorRgb.green
                    ++ " "
                    ++ String.fromFloat colorRgb.blue
                    ++ " "
                    ++ String.fromFloat colorRgb.alpha
           )


fixHex : String -> String
fixHex hex =
    if String.length hex == 1 then
        "0" ++ hex

    else
        hex


viewRadio : PaletteEditor -> (option -> Msg) -> List (Input.Option option Msg) -> Maybe option -> String -> Element Msg
viewRadio paletteEditor onChange options selected label =
    Input.radio
        [ padding 10
        , spacing 20
        ]
        { onChange = onChange
        , options = options
        , selected = selected
        , label = Input.labelAbove [] (el [] (text label))
        }


viewSlider : PaletteEditor -> (Float -> Msg) -> String -> Float -> Element Msg
viewSlider paletteEditor onChange label value =
    Input.slider
        [ height (px 2)
        , width fill
        , padding 1
        , centerY
        , Background.color (rgb 0.5 0.5 0.5)
        , Border.rounded 2
        ]
        { onChange = onChange
        , label = Input.labelAbove [] (el [] (text label))
        , min = 1
        , max = 100
        , value = value
        , thumb = Input.defaultThumb
        , step = Just 1
        }


black =
    rgb 0 0 0


white =
    rgb 1 1 1



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
        |> String.replace "<FONT_RATIO>" (String.fromFloat paletteEditor.fontRatio)
        |> String.replace "<SPACING>" (String.fromInt paletteEditor.spacing)
        |> String.replace "<PADDING>" (String.fromInt paletteEditor.padding)
        |> String.replace "<SHADOW_COLOR>" (colorToCode paletteEditor.shadowColor)
        |> String.replace "<MIDTONE_COLOR>" (colorToCode paletteEditor.midtoneColor)
        |> String.replace "<HIGHLIGHT_COLOR>" (colorToCode paletteEditor.highlightColor)
        |> String.replace "<ACCENT_COLOR>" (colorToCode paletteEditor.accentColor)


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
    , spacing : Int
    }


default : Palette
default =
    { -- Font
      fontSize = <FONT_SIZE>
    , fontRatio = <FONT_RATIO>

    -- Color
    , shadowColor = <SHADOW_COLOR>
    , midtoneColor = <MIDTONE_COLOR>
    , highlightColor = <HIGHLIGHT_COLOR>
    , accentColor = <ACCENT_COLOR>

    -- Layout
    , headerHeight = px 200
    , footerHeight = px 100
    , padding = <PADDING>
    , spacing = <SPACING>
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
