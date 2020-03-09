module Video exposing (..)

import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Video =
    { id : Int
    , title : String
    , speaker : String
    , videoUrl : String
    }


videoDecoder : Decoder Video
videoDecoder =
    Json.Decode.succeed Video
        |> required "id" Json.Decode.int
        |> required "title" Json.Decode.string
        |> required "speaker" Json.Decode.string
        |> required "videoUrl" Json.Decode.string


identifierOf : Video -> String
identifierOf video =
    let
        parts =
            String.split "?v=" video.videoUrl

        {- "parts" is guaranteed to be a non-empty list, so Maybe.withDefault is the just for technical reasons -}
        {- The KotlinJS solution doesn't care about invalid videoUrls at all -}
        identifier =
            parts
                |> List.reverse
                |> List.head
                |> Maybe.withDefault ""
    in
    identifier
