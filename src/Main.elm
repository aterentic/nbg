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
    | OpenArticle PhotoInList
    | CloseArticle PhotoInList
    | GoToFullscreen Photo
    | CloseFullscreen


type PhotoView
    = Teaser
    | Article


type alias PhotoInList =
    { index : Int
    , photo : Photo
    , photoView : PhotoView
    }


teaser : Int -> Photo -> PhotoInList
teaser index photo =
    { index = index, photo = photo, photoView = Teaser }


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    ( { list = List.indexedMap teaser Assets.photos, fullscreen = Nothing }, Cmd.none )


viewPhoto : Photo -> Msg -> List (Html Msg)
viewPhoto { headline, text, image } onHeadlineClick =
    [ div [ class "text" ] [ span [] [ Html.Styled.text text ] ]
    , div [ class "container" ] [ img [ src image ] [] ]
    , h2 [ class "headline" ] [ span [ onClick onHeadlineClick ] [ Html.Styled.text headline ] ]
    ]


viewPhotoInList : PhotoInList -> Html Msg
viewPhotoInList photoInList =
    case photoInList.photoView of
        Article ->
            div [ class "photo", class "article" ] <| viewPhoto photoInList.photo (CloseArticle photoInList) ++ [ Components.toggleFullscreen (GoToFullscreen photoInList.photo) ]

        Teaser ->
            div [ class "photo", class "teaser" ] <| viewPhoto photoInList.photo (OpenArticle photoInList) ++ [ Components.toggleFullscreen None ]


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
    Document Assets.document <|
        List.map toUnstyled <|
            viewHeader Assets.header Assets.description
                :: List.map viewPhotoInList model.list
                ++ viewFullscreen model.fullscreen
                ++ [ viewFooter ]


updatePhotoView : Int -> PhotoView -> List PhotoInList -> List PhotoInList
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
        OpenArticle { index } ->
            ( { model | list = updatePhotoView index Article model.list, fullscreen = Nothing }, Cmd.none )

        CloseArticle { index } ->
            ( { model | list = updatePhotoView index Teaser model.list, fullscreen = Nothing }, Cmd.none )

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
