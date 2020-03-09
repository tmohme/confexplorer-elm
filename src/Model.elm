module Model exposing (Model)

import Video exposing (Video)


type alias Model =
    { currentVideo : Maybe Video
    , watchedVideos : List Video
    , unwatchedVideos : List Video
    }
