module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Assets
import Browser exposing (Document)
import Browser.Navigation
import Components
import Data exposing (Photo)
import Html.Styled exposing (Html, div, h1, h2, h3, header, img, span, text, toUnstyled)
import Html.Styled.Attributes exposing (class, src)
import Html.Styled.Events exposing (onClick)
import Url exposing (Url)


type alias Flags =
    {}


type alias Model =
    { list : List PhotoInList
    , fullscreen : Maybe Photo
    }


type Msg
    = None
    | OpenArticle Int
    | CloseArticle Int
    | GoToFullscreen Photo
    | CloseFullscreen


type alias PhotoInList =
    { index : Int
    , photo : Photo
    , photoView : Components.PhotoView
    }


teaser : Int -> Photo -> PhotoInList
teaser index photo =
    { index = index, photo = photo, photoView = Components.Teaser }


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    ( { list = List.indexedMap teaser Assets.photos, fullscreen = Nothing }, Cmd.none )


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
            \{ photo, photoView, index } ->
                case photoView of
                    Components.Article ->
                        Components.photo Components.Article photo (CloseArticle index) (GoToFullscreen photo)

                    Components.Teaser ->
                        Components.photo Components.Teaser photo (OpenArticle index) None
    in
    Document Assets.document <|
        List.map toUnstyled <|
            viewHeader Assets.header Assets.description
                :: List.map pv model.list
                ++ viewFullscreen model.fullscreen
                ++ [ viewFooter ]


updatePhotoView : Int -> Components.PhotoView -> List PhotoInList -> List PhotoInList
updatePhotoView index photoView list =
    List.map
        (\p ->
            if p.index == index then
                { p | photoView = photoView }

            else
                p
        )
        list


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenArticle index ->
            ( { model | list = updatePhotoView index Components.Article model.list, fullscreen = Nothing }, Cmd.none )

        CloseArticle index ->
            ( { model | list = updatePhotoView index Components.Teaser model.list, fullscreen = Nothing }, Cmd.none )

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
