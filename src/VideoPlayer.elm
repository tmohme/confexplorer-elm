module VideoPlayer exposing (Msg, update, view)

import Css exposing (absolute, backgroundColor, block, display, position, px, right, top)
import Css.Colors exposing (lightgreen, red)
import Html.Styled exposing (Html, button, div, h3, img, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import Model exposing (Model)
import Video exposing (Video)


type Msg
    = ToggleButtonClicked Video


view : Video -> Bool -> Html Msg
view video watched =
    let
        buttonColor =
            if watched then
                red

            else
                lightgreen

        buttonText =
            if watched then
                "Mark as unwatched"

            else
                "Mark as watched"
    in
    div [ css [ position absolute, top (px 10), right (px 10) ] ]
        [ h3 [] [ text (video.speaker ++ ": " ++ video.title) ]
        , button [ css [ display block, backgroundColor buttonColor ], onClick (ToggleButtonClicked video) ] [ text buttonText ]
        , img [ src "https://via.placeholder.com/640x360.png?text=Video+Player+Placeholder" ] []
        ]


update : Msg -> (Video -> Model) -> Model
update msg toggleFunction =
    case msg of
        ToggleButtonClicked video ->
            toggleFunction video
