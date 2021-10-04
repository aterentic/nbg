module Gallery exposing (ListPhoto(..), Model, Msg(..), Photo, article, bodyStyle, container, init, photoHeadline, teaser, update, view, viewFullscreen, viewPhotoInList, viewPhotos)

import Array exposing (Array)
import Browser exposing (Document)
import Browser.Navigation as Navigation
import Components.Common as Common exposing (fullscreenIcon)
import Components.Photo as Photo
import Components.Utils exposing (black, blue, topLeft)
import Css exposing (absolute, backgroundColor, bottom, em, fontFamilies, height, hidden, int, margin, margin4, overflow, overflowX, pct, position, px, relative, vw, width, zIndex, zero)
import Css.Global exposing (global, selector)
import Html.Styled exposing (Attribute, Html, div, span, styled, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Url


type alias Photo =
    { headline : String
    , text : String
    , image : String
    }


type alias Model =
    { list : Array ListPhoto
    , fullscreen : Maybe String
    }


type Msg
    = None
    | TeaserHeadlineClicked Int Photo
    | ArticleHeadlineClicked Int Photo
    | OpenFullscreen String
    | CloseFullscreen


type ListPhoto
    = Teaser
        { photo : Photo
        , headlineClicked : Msg
        }
    | Article
        { photo : Photo
        , headlineClicked : Msg
        , fullscreenClicked : Msg
        }


teaser : Int -> Photo -> ListPhoto
teaser index photo =
    Teaser
        { photo = photo
        , headlineClicked = TeaserHeadlineClicked index photo
        }


article : Int -> Photo -> ListPhoto
article index photo =
    Article
        { photo = photo
        , headlineClicked = ArticleHeadlineClicked index photo
        , fullscreenClicked = OpenFullscreen photo.image
        }


init : List Photo -> flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init photos =
    \_ _ _ -> ( Model (Array.indexedMap teaser <| Array.fromList photos) Nothing, Cmd.none )


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


container : List (Attribute msg) -> List (Html msg) -> Html msg
container =
    styled div
        [ position relative, overflow hidden, width (vw 100) ]


photoHeadline : Float -> String -> msg -> Html msg
photoHeadline bottomPercent headlineText headlineClick =
    Common.blueHeadline
        [ onClick headlineClick
        , css
            [ margin4 zero zero (em 1) (pct 5)
            , position absolute
            , bottom (pct bottomPercent)
            , zIndex (int 1)
            ]
        ]
        [ span [] [ Html.Styled.text headlineText ] ]


viewPhotoInList : ListPhoto -> Html Msg
viewPhotoInList photoInList =
    case photoInList of
        Teaser { photo, headlineClicked } ->
            -- calc(100vw / 16 * 3); Images ratio is 4:3, 1/4 of image is displayed
            container
                [ css [ height (vw 18.75), backgroundColor black ] ]
                [ photoHeadline 0 photo.headline headlineClicked -- (HeadlineClicked index photo)
                , Photo.teaserImage photo.image
                ]

        Article { photo, headlineClicked, fullscreenClicked } ->
            -- calc(50vw / 4 * 3); Images ratio is 4:3, whole image is displayed
            container
                [ css [ height (vw 37.5), backgroundColor black ] ]
                [ photoHeadline 8 photo.headline headlineClicked
                , Photo.articleImage photo.image
                , Photo.articleText photo.text
                , Common.blueButton
                    [ onClick fullscreenClicked, css [ topLeft (pct 10) (pct 5) ] ]
                    [ fullscreenIcon ]
                ]


viewPhotos : Array ListPhoto -> Html Msg
viewPhotos list =
    div [] <| Array.toList <| Array.map viewPhotoInList list


viewFullscreen : Maybe String -> List (Html Msg)
viewFullscreen fullscreen =
    case fullscreen of
        Nothing ->
            []

        Just image ->
            [ Common.fullscreen CloseFullscreen image ]


view : String -> String -> String -> Model -> Document Msg
view title headline description model =
    Document title <|
        List.map toUnstyled <|
            [ bodyStyle
            , Common.header headline description
            , viewPhotos model.list
            , Common.footer
            ]
                ++ viewFullscreen model.fullscreen


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeaserHeadlineClicked index photo ->
            ( { model | list = Array.set index (article index photo) model.list, fullscreen = Nothing }, Cmd.none )

        ArticleHeadlineClicked index photo ->
            ( { model | list = Array.set index (teaser index photo) model.list, fullscreen = Nothing }, Cmd.none )

        OpenFullscreen photo ->
            ( { model | fullscreen = Just photo }, Cmd.none )

        CloseFullscreen ->
            ( { model | fullscreen = Nothing }, Cmd.none )

        None ->
            ( model, Cmd.none )
