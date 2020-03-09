module VideoPlayer exposing (Msg, update, view)

import Css exposing (absolute, backgroundColor, block, display, position, px, right, top)
import Css.Colors exposing (lightgreen, red)
import Embed.Youtube
import Embed.Youtube.Attributes
import Html.Styled exposing (Html, button, div, fromUnstyled, h3, text)
import Html.Styled.Attributes exposing (css)
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
        , Embed.Youtube.fromString video.videoUrl
            |> Embed.Youtube.attributes
                [ Embed.Youtube.Attributes.width 640
                , Embed.Youtube.Attributes.height 360
                ]
            |> Embed.Youtube.toHtml
            |> fromUnstyled
        ]


update : Msg -> (Video -> Model) -> Model
update msg toggleFunction =
    case msg of
        ToggleButtonClicked video ->
            toggleFunction video
