module Main exposing (..)

import Browser
import Html.Styled exposing (Html, div, h1, h3, p, text, toUnstyled)
import Html.Styled.Events exposing (onClick)
import List exposing (map)
import Model exposing (Model)
import Video exposing (Video)
import VideoPlayer


type Msg
    = Clicked Video
    | VideoPlayerMsg VideoPlayer.Msg


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


update : Msg -> Model -> Model
update msg model =
    case msg of
        Clicked video ->
            { model | currentVideo = Just video }

        VideoPlayerMsg videoPlayerMsg ->
            VideoPlayer.update videoPlayerMsg (toggleVideo model)


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


initiallyUnwatchedVideos =
    [ Video 1 "Building and breaking things" "John Doe" "jl1tGiUiTtI"
    , Video 2 "The development process" "Jane Smith" "jl1tGiUiTtI"
    , Video 3 "The Web 7.0" "Matt Miller" "jl1tGiUiTtI"
    ]


initiallyWatchedVideos =
    [ Video 4 "Mouseless development" "Tom Jerry" "jl1tGiUiTtI" ]


initialModel =
    { currentVideo = Nothing
    , watchedVideos = initiallyWatchedVideos
    , unwatchedVideos = initiallyUnwatchedVideos
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view >> toUnstyled
        }
