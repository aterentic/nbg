module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Array exposing (Array)
import Assets
import Browser exposing (Document)
import Browser.Navigation
import Components
import Data exposing (Photo)
import Html.Styled exposing (Html, div, h1, h3, header, img, text, toUnstyled)
import Html.Styled.Attributes exposing (class, src)
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


viewFullscreen : Maybe Photo -> List (Html Msg)
viewFullscreen fp =
    Maybe.withDefault [] <| Maybe.map (\photo -> [ div [ class "fullscreen" ] [ img [ src photo.image ] [], Components.toggleFullscreen CloseFullscreen ] ]) fp


viewHeader : String -> String -> Html msg
viewHeader headline description =
    header [] [ h1 [] [ text headline ], h3 [] [ text description ] ]


viewFooter : Html msg
viewFooter =
    div [ class "footer" ] []


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
            viewHeader Assets.header Assets.description
                :: Array.toList (Array.indexedMap pv model.list)
                ++ viewFullscreen model.fullscreen
                ++ [ viewFooter ]


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
