module Main exposing (..)

import Browser
import Css exposing (absolute, position, px, right, top)
import Html.Styled exposing (Html, div, h1, h3, img, p, text, toUnstyled)
import Html.Styled.Attributes exposing (css, src)


type alias Model =
    {}


type Msg
    = Msg


view : Model -> Html Msg
view _ =
    div []
        [ h1 [] [ text "KotlinConf Explorer" ]
        , div []
            [ h3 [] [ text "Videos to watch" ]
            , p [] [ text "John Doe: Building and breaking things" ]
            , p [] [ text "Jane Smith: The development process" ]
            , p [] [ text "Matt Miller: The Web 7.0" ]
            , h3 [] [ text "Videos to watched" ]
            , p [] [ text "Tom Jerry: Mouseless development" ]
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
