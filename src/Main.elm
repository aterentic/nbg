module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Browser exposing (Document)
import Browser.Navigation
import Html exposing (Html, div, h1, h2, header, img, span, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Url exposing (Url)


firstIs : Photo -> PhotoInList
firstIs =
    Hidden


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


type alias Photo =
    { index : Int
    , headline : String
    , text : String
    , image : String
    }


photos : List Photo
photos =
    List.indexedMap (\i { headline, text, image } -> { index = i, headline = headline, text = text, image = image })
        [ { headline = "Međublokovski prostor"
          , text = "Zapravo, zato smo se i doselili ovde. Automobili samo kod garaža, sa jedne strane klinci muljaju po pesku, igraju fudbal na male goliće, platani ih hlade kad je 37 stepeni, kad otvoriš prozor, neko se dere \"Maaaaaamaaaaa\", uveče klinci vare na klupi, i, jebi ga, malo se deru kad treba da se spava. Gomila nedovršenog zelenila i prostora, vidiš komšijin prozor, ali u daljini. Između zapravo možeš da sediš na klupi u hladu, da čekaš klince dok voze bajs, da čekaš klince dok se zimi sankaju niz brdašce od atomskog skloništa. Čak i sneška možeš da praviš jer je površina dovoljno velika da sneg ne upropasti masa ljudi i vozila. A ima i baštica, uvek ima nekog ko bi da se petlja sa tim."
          , image = "assets/01.jpg"
          }
        ]


init : flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ _ _ =
    case photos of
        x :: xs ->
            ( firstIs x :: List.map Hidden xs, Cmd.none )

        [] ->
            ( [], Cmd.none )


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
