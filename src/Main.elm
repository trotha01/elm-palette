module Main exposing (Flags, Model, Msg(..), Route(..), init, main, routeParser, subscriptions, title, update, view, viewContent, viewFooter, viewHeader)

import Browser exposing (..)
import Browser.Dom as Dom
import Browser.Events exposing (..)
import Browser.Navigation as Nav
import Components
import Element exposing (..)
import Html exposing (Html)
import Lorem
import Palette.Editor as Palette exposing (PaletteEditor)
import Palette.Palette as Palette exposing (Palette)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- Routes


type Route
    = Home
    | Calendar
    | Homework
    | ServiceOpportunities
    | Contact


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home (s "/")
        , map Calendar (s "/calendar")
        ]



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , palette : Palette
    , paletteEditor : PaletteEditor
    }


type alias Flags =
    {}


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        palette =
            Palette.default
    in
    ( { key = key
      , url = url
      , palette = palette
      , paletteEditor = Palette.init palette
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PaletteMsg Palette.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        PaletteMsg paletteMsg ->
            let
                newPaletteEditor =
                    Palette.update paletteMsg model.paletteEditor

                newPalette =
                    Palette.fromEditor newPaletteEditor
            in
            ( { model | paletteEditor = newPaletteEditor, palette = newPalette }
            , Cmd.none
            )



-- VIEW


view : Model -> Document Msg
view model =
    { title = title
    , body =
        [ Element.layout [ inFront (Element.map PaletteMsg (Palette.view model.paletteEditor)) ]
            (column [ width fill, height fill ]
                [ Components.header model.palette viewHeader
                , Components.content model.palette (viewContent model.palette)
                , Components.footer model.palette viewFooter
                ]
            )
        ]
    }


title : String
title =
    "Title"


viewHeader : Element Msg
viewHeader =
    el [] (text "Header")


viewContent : Palette -> Element Msg
viewContent palette =
    column [ width fill, spacing palette.spacing, padding palette.padding ]
        [ viewContentRow1 palette
        , viewContentRow2 palette
        , viewContentRow3 palette
        , viewContentRow4 palette
        , viewContentRow5 palette
        ]


viewContentRow1 : Palette -> Element Msg
viewContentRow1 palette =
    row
        [ width fill
        , spacing palette.spacing
        , padding palette.padding
        ]
        [ Components.card palette viewCard1
        , Components.card palette viewCard2
        , Components.card palette viewCard3
        ]


viewContentRow2 : Palette -> Element Msg
viewContentRow2 palette =
    row
        [ width fill
        , spacing palette.spacing
        , padding palette.padding
        ]
        [ Components.card palette viewCard1
        , Components.card palette viewCard2
        , Components.card palette viewCard3
        ]


viewContentRow3 : Palette -> Element Msg
viewContentRow3 palette =
    column
        [ width fill
        , spacing palette.spacing
        , padding palette.padding
        ]
        [ Components.h1 palette "Title"
        , Components.p palette (Lorem.sentence 10)
        ]


viewContentRow4 : Palette -> Element Msg
viewContentRow4 palette =
    column
        [ width fill
        , spacing palette.spacing
        , padding palette.padding
        ]
        [ Components.h2 palette "Sub Title 1"
        , Components.p palette (Lorem.sentence 50)
        ]


viewContentRow5 : Palette -> Element Msg
viewContentRow5 palette =
    column
        [ width fill
        , spacing palette.spacing
        , padding palette.padding
        ]
        [ Components.h2 palette "Sub Title 2"
        , Components.p palette (Lorem.sentence 50)
        ]


viewCard1 : Element Msg
viewCard1 =
    el [] (text "Card 1")


viewCard2 : Element Msg
viewCard2 =
    el [] (text "Card 2")


viewCard3 : Element Msg
viewCard3 =
    el [] (text "Card 3")


viewFooter : Element Msg
viewFooter =
    el [] (text "footer")



{--
logo : Html Msg
logo =
    img
        [ src "imgs/White dove.png"
        , class "logo"
        ]
        []
--}
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map PaletteMsg (Palette.subscriptions model.paletteEditor)
