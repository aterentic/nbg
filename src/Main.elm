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
    | Toggle PhotoInList


type PhotoInList
    = Visible Photo
    | Hidden Photo


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    ( List.map Hidden Assets.photos, Cmd.none )


viewImage : String -> Html Msg
viewImage image =
    div [ class "container" ] [ img [ src image ] [] ]


viewText : String -> Html Msg
viewText text =
    div [ class "text" ] [ span [] [ Html.text text ] ]


viewPhoto : Photo -> String -> Msg -> Html Msg
viewPhoto { headline, text, image } imageClass onHeadlineClick =
    div [ class "photo", class imageClass ]
        [ viewText text
        , viewImage image
        , h1 [ class "headline" ] [ span [ onClick onHeadlineClick ] [ Html.text headline ] ]
        ]


viewPhotoInList : PhotoInList -> Html Msg
viewPhotoInList photoInList =
    case photoInList of
        Visible photo ->
            viewPhoto photo "opened" <| Toggle photoInList

        Hidden photo ->
            viewPhoto photo "closed" <| Toggle photoInList


viewHeader : String -> String -> Html msg
viewHeader headline description =
    header [] [ h1 [] [ text headline ], h2 [] [ text description ] ]


viewFooter : Html msg
viewFooter =
    div [ class "footer" ] []


view : Model -> Document Msg
view model =
    Document "NBG" <|
        viewHeader "NBG KOLAŽ" "Blokovi, Sava, i poneki opis..."
            :: List.map viewPhotoInList model
            ++ [ viewFooter ]


indexOf : PhotoInList -> Int
indexOf photoInList =
    case photoInList of
        Visible photo ->
            photo.index

        Hidden photo ->
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


toggle : PhotoInList -> PhotoInList
toggle photoInList =
    case photoInList of
        Visible photo ->
            Hidden photo

        Hidden photo ->
            Visible photo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Toggle photo ->
            ( replace model (toggle photo), Cmd.none )

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
