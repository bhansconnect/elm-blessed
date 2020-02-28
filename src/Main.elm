module Main exposing (main)

import Blessed exposing (button, form, root)
import Blessed.Events exposing (onPress)
import Blessed.Props exposing (..)
import Command
import Json.Decode exposing (Decoder, Value, andThen, decodeValue, errorToString, field, string, succeed)
import Platform



-- Model


type alias Model =
    { counter : Int
    }



-- Messages from JS


type Msg
    = Inc
    | Dec
    | Error String


decodeMsg : Value -> Msg
decodeMsg json =
    case decodeValue msgDecoder json of
        Ok msg ->
            msg

        Err err ->
            Error (errorToString err)


msgDecoder : Decoder Msg
msgDecoder =
    Command.decoder
        |> andThen
            (\cmd ->
                case cmd of
                    Command.Inc ->
                        succeed Inc

                    Command.Dec ->
                        succeed Dec
            )



-- Core Progam


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    let
        model : Model
        model =
            { counter = 0 }
    in
    Blessed.sendModel view ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Blessed.sendModelIfChanged view model <|
        case msg of
            Inc ->
                let
                    newModel =
                        { model | counter = model.counter + 1 }
                in
                ( newModel, Cmd.none )

            Dec ->
                let
                    newModel =
                        { model | counter = model.counter - 1 }
                in
                ( newModel, Cmd.none )

            Error err ->
                ( model, Blessed.sendError err )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Blessed.recieveMessage decodeMsg



-- View


view : Model -> Value
view model =
    root Command.encode
        []
        []
        [ form
            [ top "center"
            , left "center"
            , align "center"
            , width "50%"
            , heightExact 5
            , content (String.fromInt model.counter)
            , keys True
            , border [ fg "blue", kind "line" ]
            ]
            []
            [ button
                [ leftExact 10
                , heightExact 3
                , widthExact 5
                , align "center"
                , content "-"
                , keys True
                , style [ focus [ bg "red" ] ]
                , border [ kind "line" ]
                ]
                [ onPress Command.Dec ]
                []
            , button
                [ rightExact 10
                , heightExact 3
                , widthExact 5
                , align "center"
                , content "+"
                , keys True
                , style [ focus [ bg "red" ] ]
                , border [ kind "line" ]
                ]
                [ onPress Command.Inc ]
                []
            ]
        ]
