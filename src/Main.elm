module Main exposing (..)

import Browser
import Css exposing (absolute, position, px, right, top)
import Html.Styled exposing (Html, div, h1, h3, img, p, text, toUnstyled)
import Html.Styled.Attributes exposing (css, src)
import List exposing (map)


type alias Video =
    { id : Int
    , title : String
    , speaker : String
    , videoUrl : String
    }


type alias Model =
    {}


type Msg
    = Msg


unwatchedVideos =
    [ Video 1 "Building and breaking things" "John Doe" "https://youtu.be/PsaFVLr8t4E"
    , Video 2 "The development process" "Jane Smith" "https://youtu.be/PsaFVLr8t4E"
    , Video 3 "The Web 7.0" "Matt Miller" "https://youtu.be/PsaFVLr8t4E"
    ]


watchedVideos =
    [ Video 4 "Mouseless development" "Tom Jerry" "https://youtu.be/PsaFVLr8t4E" ]


view : Model -> Html Msg
view _ =
    div []
        [ h1 [] [ text "KotlinConf Explorer" ]
        , div []
            [ h3 [] [ text "Videos to watch" ]
            , div [] <| map (\v -> p [] [ text v.title ]) unwatchedVideos
            , h3 [] [ text "Videos watched" ]
            , div [] <| map (\v -> p [] [ text v.title ]) watchedVideos
            ]
        , div [ css [ position absolute, top (px 10), right (px 10) ] ]
            [ h3 [] [ text "John Doe: Building and breaking things" ]
            , img [ src "https://via.placeholder.com/640x360.png?text=Video+Player+Placeholder" ] []
            ]
        ]


update _ model =
    model


main : Program () Model Msg
main =
    Browser.sandbox
        { init = Model
        , update = update
        , view = view >> toUnstyled
        }
