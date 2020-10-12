module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Array exposing (Array)
import Assets
import Browser exposing (Document)
import Browser.Navigation
import Components.Common as Common
import Components.Photo
import Components.Utils exposing (blue)
import Css exposing (backgroundColor, fontFamilies, hidden, margin, overflowX, px)
import Css.Global exposing (global, selector)
import Data exposing (Photo)
import Html.Styled exposing (Html, div, header, toUnstyled)
import Url exposing (Url)


type alias Flags =
    {}


type alias Model =
    { list : Array PhotoInList
    , fullscreen : Maybe Photo
    }


type PhotoView
    = Article
    | Teaser


type Msg
    = None
    | OpenArticle Int Photo
    | CloseArticle Int Photo
    | GoToFullscreen Photo
    | CloseFullscreen


type alias PhotoInList =
    { photo : Photo
    , photoView : PhotoView
    }


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    let
        teaser =
            \photo -> { photo = photo, photoView = Teaser }
    in
    ( { list = Array.map teaser <| Array.fromList Assets.photos, fullscreen = Nothing }, Cmd.none )


bodyStyle : Html msg
bodyStyle =
    global
        [ selector "body"
            [ overflowX hidden
            , margin (px 0)
            , backgroundColor blue
            , fontFamilies [ "Roboto Condensed" ]
            ]
        ]


viewPhoto : Float -> Int -> PhotoInList -> Html Msg
viewPhoto animationDuration index { photo, photoView } =
    case photoView of
        Article ->
            Components.Photo.article animationDuration photo (CloseArticle index photo) (GoToFullscreen photo)

        Teaser ->
            Components.Photo.teaser animationDuration photo (OpenArticle index photo) None


viewPhotos : Array PhotoInList -> Html Msg
viewPhotos list =
    div [] <| Array.toList <| Array.indexedMap (viewPhoto 333) list


viewFullscreen : Maybe Photo -> List (Html Msg)
viewFullscreen fullscreen =
    case fullscreen of
        Nothing ->
            []

        Just { image } ->
            [ Common.fullscreen CloseFullscreen image ]


view : Model -> Document Msg
view model =
    Document Assets.document <|
        List.map toUnstyled <|
            bodyStyle
                :: Common.header Assets.headline Assets.description
                :: viewPhotos model.list
                :: Common.footer
                :: viewFullscreen model.fullscreen


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenArticle index photo ->
            ( { model | list = Array.set index { photoView = Article, photo = photo } model.list, fullscreen = Nothing }, Cmd.none )

        CloseArticle index photo ->
            ( { model | list = Array.set index { photoView = Teaser, photo = photo } model.list, fullscreen = Nothing }, Cmd.none )

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
