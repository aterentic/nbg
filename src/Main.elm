module Main exposing (Flags, Model, Msg(..), init, main, update, view)

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
    | HeadlineClicked Int PhotoInList
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


viewPhoto : Float -> PhotoInList -> Msg -> Html Msg
viewPhoto animationDuration { photo, photoView } headlineClick =
    case photoView of
        Article ->
            Components.Photo.article animationDuration photo headlineClick (GoToFullscreen photo)

        Teaser ->
            Components.Photo.teaser animationDuration photo headlineClick None


viewPhotoInList : Float -> Int -> PhotoInList -> Html Msg
viewPhotoInList animationDuration index photoInList =
    viewPhoto animationDuration photoInList (HeadlineClicked index photoInList)


viewPhotos : Array PhotoInList -> Html Msg
viewPhotos list =
    div [] <| Array.toList <| Array.indexedMap (viewPhotoInList 333) list


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



-- ( { model | list = Array.set index { photoView = ToArticle, photo = photo } model.list }, Task.perform (\_ -> OpenArticle index photo) (Process.sleep 500) )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeadlineClicked index { photo, photoView } ->
            case photoView of
                Teaser ->
                    ( { model | list = Array.set index { photoView = Article, photo = photo } model.list, fullscreen = Nothing }, Cmd.none )

                Article ->
                    ( { model | list = Array.set index { photoView = Teaser, photo = photo } model.list, fullscreen = Nothing }, Cmd.none )

        GoToFullscreen photo ->
            ( { model | fullscreen = Just photo }, Cmd.none )

        CloseFullscreen ->
            ( { model | fullscreen = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


main : Platform.Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = \_ -> None
        , onUrlChange = \_ -> None
        }
