module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation
import Html exposing (text)
import Url exposing (Url)


type alias Flags =
    {}


type alias Model =
    {}


type Msg
    = None


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    ( {}, Cmd.none )


view : Model -> Document Msg
view _ =
    Document "NBG" [ text "NBG" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update _ _ =
    ( {}, Cmd.none )


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
