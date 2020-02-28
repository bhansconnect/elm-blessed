module Command exposing (Command(..), decoder, encode)

import Json.Decode as Decode exposing (Decoder, andThen, fail, field, succeed)
import Json.Encode as Encode exposing (Value, object)



-- Command To JS


type Command
    = Inc
    | Dec


encode : Command -> Value
encode cmd =
    case cmd of
        Inc ->
            object [ ( "command", Encode.string "Inc" ) ]

        Dec ->
            object [ ( "command", Encode.string "Dec" ) ]


decoder : Decode.Decoder Command
decoder =
    field "command" Decode.string
        |> andThen
            (\cmd ->
                case cmd of
                    "Inc" ->
                        succeed Inc

                    "Dec" ->
                        succeed Dec

                    err ->
                        fail <| "Unknown command: " ++ err
            )
