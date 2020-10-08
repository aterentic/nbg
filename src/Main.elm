module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Array exposing (Array)
import Assets
import Browser exposing (Document)
import Browser.Navigation
import Components
import Css exposing (backgroundColor, fontFamilies, hidden, margin, overflowX, px)
import Css.Global exposing (global, selector)
import Data exposing (Photo)
import Html.Styled exposing (Html, header, toUnstyled)
import Url exposing (Url)


type alias Flags =
    {}


type alias Model =
    { list : Array PhotoInList
    , fullscreen : Maybe Photo
    }


type Msg
    = None
    | OpenArticle Int Photo
    | CloseArticle Int Photo
    | GoToFullscreen Photo
    | CloseFullscreen


type alias PhotoInList =
    { photo : Photo
    , photoView : Components.PhotoView
    }


teaser : Int -> Photo -> PhotoInList
teaser _ photo =
    { photo = photo, photoView = Components.Teaser }


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    ( { list = Array.fromList <| List.indexedMap teaser Assets.photos, fullscreen = Nothing }, Cmd.none )


bodyStyle : Html msg
bodyStyle =
    global
        [ selector "body"
            [ overflowX hidden
            , margin (px 0)
            , backgroundColor Components.blue
            , fontFamilies [ "Roboto Condensed" ]
            ]
        ]


view : Model -> Document Msg
view model =
    let
        pv =
            \index { photo, photoView } ->
                case photoView of
                    Components.Article ->
                        Components.photo Components.Article photo (CloseArticle index photo) (GoToFullscreen photo)

                    Components.Teaser ->
                        Components.photo Components.Teaser photo (OpenArticle index photo) None
    in
    Document Assets.document <|
        List.map toUnstyled <|
            bodyStyle
                :: Components.header Assets.headline Assets.description
                :: Array.toList (Array.indexedMap pv model.list)
                ++ Maybe.withDefault [] (Maybe.map (\{ image } -> [ Components.fullscreen CloseFullscreen image ]) model.fullscreen)
                ++ [ Components.footer ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenArticle index photo ->
            ( { model | list = Array.set index { photoView = Components.Article, photo = photo } model.list, fullscreen = Nothing }, Cmd.none )

        CloseArticle index photo ->
            ( { model | list = Array.set index { photoView = Components.Teaser, photo = photo } model.list, fullscreen = Nothing }, Cmd.none )

        GoToFullscreen photo ->
            ( { model | fullscreen = Just photo }, Cmd.none )

        CloseFullscreen ->
            ( { model | fullscreen = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Platform.Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> None
        , onUrlChange = \_ -> None
        }
