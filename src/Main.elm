module Main exposing (Flags, Model, Msg(..), Route(..), init, main, routeParser, subscriptions, title, update, view, viewContent, viewFooter, viewHeader)

import Browser exposing (..)
import Browser.Dom as Dom
import Browser.Events exposing (..)
import Browser.Navigation as Nav
import Components
import Element exposing (..)
import Html exposing (Html)
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
    ( { key = key
      , url = url
      , palette = Palette.default
      , paletteEditor = Palette.init
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
    column []
        [ row [ width (fillPortion 1) ] [ Components.card palette ]
        , row [ width (fillPortion 1) ] [ Components.card palette ]
        , row [ width (fillPortion 1) ] [ Components.card palette ]
        ]


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
