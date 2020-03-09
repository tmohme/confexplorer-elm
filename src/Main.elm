module Main exposing (..)

import Browser
import Html.Styled exposing (Html, div, h1, h3, p, text, toUnstyled)
import Html.Styled.Events exposing (onClick)
import Http
import List exposing (map)
import Model exposing (Model)
import String exposing (fromInt)
import Video exposing (Video, videoDecoder)
import VideoPlayer


type Msg
    = Clicked Video
    | VideoPlayerMsg VideoPlayer.Msg
    | VideoLoaded (Result Http.Error Video)


view : Model -> Html.Styled.Html Msg
view model =
    div []
        [ h1 [] [ text "KotlinConf Explorer" ]
        , viewVideoList "Videos to watch" model.unwatchedVideos model.currentVideo
        , viewVideoList "Videos watched" model.watchedVideos model.currentVideo
        , viewPlayer model
        ]


viewPlayer : Model -> Html Msg
viewPlayer model =
    case model.currentVideo of
        Just aVideo ->
            let
                watched =
                    List.member aVideo model.watchedVideos
            in
            VideoPlayer.view aVideo watched |> Html.Styled.map VideoPlayerMsg

        Nothing ->
            div [] []


viewVideoList : String -> List Video -> Maybe Video -> Html.Styled.Html Msg
viewVideoList title videos selectedVideo =
    div []
        [ h3 [] [ text title ]
        , div [] <| map (viewVideo selectedVideo) videos
        ]


viewVideo : Maybe Video -> Video -> Html.Styled.Html Msg
viewVideo selectedVideo video =
    let
        selectionMarker =
            case selectedVideo of
                Nothing ->
                    ""

                Just aVideo ->
                    if video == aVideo then
                        "▶"

                    else
                        ""
    in
    p [ onClick <| Clicked video ] [ text (selectionMarker ++ video.speaker ++ ": " ++ video.title) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Clicked video ->
            ( { model | currentVideo = Just video }, Cmd.none )

        VideoPlayerMsg videoPlayerMsg ->
            ( VideoPlayer.update videoPlayerMsg (toggleVideo model), Cmd.none )

        VideoLoaded (Ok video) ->
            let
                unwatchedVideos =
                    (video :: model.unwatchedVideos) |> List.sortBy (\v -> v.id)
            in
            ( { model | unwatchedVideos = unwatchedVideos }, Cmd.none )

        {- No handling of any errors as the KotlinJS also ignores any errors -}
        VideoLoaded (Err _) ->
            ( model, Cmd.none )


toggleVideo : Model -> Video -> Model
toggleVideo model video =
    { model
        | watchedVideos = toggle video model.watchedVideos
        , unwatchedVideos = toggle video model.unwatchedVideos
    }


toggle : Video -> List Video -> List Video
toggle video videos =
    if List.member video videos then
        List.filter (\v -> v /= video) videos

    else
        video :: videos


initialModel =
    { currentVideo = Nothing
    , watchedVideos = []
    , unwatchedVideos = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        fetchVideos =
            List.map fetchVideo (List.range 1 25)
    in
    ( initialModel, Cmd.batch fetchVideos )


fetchVideo : Int -> Cmd Msg
fetchVideo id =
    Http.get
        { url = "https://my-json-server.typicode.com/kotlin-hands-on/kotlinconf-json/videos/" ++ fromInt id
        , expect = Http.expectJson VideoLoaded videoDecoder
        }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view >> toUnstyled
        }
