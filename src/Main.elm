module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Assets
import Browser exposing (Document)
import Browser.Navigation
import Data exposing (Photo)
import Html exposing (Html, div, h1, h2, header, img, span, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Url exposing (Url)


type alias Flags =
    {}


type alias Model =
    List PhotoInList


type Msg
    = None
    | Open PhotoInList
    | Close PhotoInList
    | Fullscreen PhotoInList


type PhotoInList
    = Visible Photo
    | Hidden Photo
    | Full Photo


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    ( List.map Hidden Assets.photos, Cmd.none )


viewImage : String -> Html Msg
viewImage image =
    div [ class "container" ] [ img [ src image ] [] ]


viewText : String -> Html Msg
viewText text =
    div [ class "text" ] [ span [] [ Html.text text ] ]


viewPhoto : Photo -> String -> Msg -> Msg -> Html Msg
viewPhoto { headline, text, image } imageClass onHeadlineClick onFullscreenClick =
    div [ class "photo", class imageClass ]
        [ viewText text
        , viewImage image
        , h1 [ class "headline" ] [ span [ onClick onHeadlineClick ] [ Html.text headline ] ]
        , span [ class "fullscreen", onClick onFullscreenClick ] [ Html.text <| String.fromChar '⛶' ]
        ]


viewPhotoInList : PhotoInList -> Html Msg
viewPhotoInList photoInList =
    case photoInList of
        Visible photo ->
            viewPhoto photo "opened" (Close photoInList) (Fullscreen photoInList)

        Hidden photo ->
            viewPhoto photo "closed" (Open photoInList) (Fullscreen photoInList)

        Full photo ->
            viewPhoto photo "fullscreen" (Close photoInList) (Close photoInList)


viewHeader : String -> String -> Html msg
viewHeader headline description =
    header [] [ h1 [] [ text headline ], h2 [] [ text description ] ]


viewFooter : Html msg
viewFooter =
    div [ class "footer" ] []


view : Model -> Document Msg
view model =
    Document Assets.document <|
        viewHeader Assets.header Assets.description
            :: List.map viewPhotoInList model
            ++ [ viewFooter ]


indexOf : PhotoInList -> Int
indexOf photoInList =
    case photoInList of
        Visible photo ->
            photo.index

        Hidden photo ->
            photo.index

        Full photo ->
            photo.index


replace : List PhotoInList -> PhotoInList -> List PhotoInList
replace list element =
    let
        replaceElement =
            \index photoInList ->
                if index == indexOf element then
                    element

                else
                    photoInList
    in
    List.indexedMap replaceElement list


open : PhotoInList -> PhotoInList
open photoInList =
    case photoInList of
        Hidden photo ->
            Visible photo

        _ ->
            photoInList


close : PhotoInList -> PhotoInList
close photoInList =
    case photoInList of
        Visible photo ->
            Hidden photo

        Full photo ->
            Hidden photo

        _ ->
            photoInList


fullscreen : PhotoInList -> PhotoInList
fullscreen photoInList =
    case photoInList of
        Hidden photo ->
            Full photo

        _ ->
            photoInList


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open photo ->
            ( replace model (open photo), Cmd.none )

        Close photo ->
            ( replace model (close photo), Cmd.none )

        Fullscreen photo ->
            ( replace model (fullscreen photo), Cmd.none )

        None ->
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
