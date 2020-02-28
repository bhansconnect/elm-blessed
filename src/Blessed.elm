port module Blessed exposing (Event(..), Prop(..), box, button, form, recieveMessage, root, sendError, sendModel, sendModelIfChanged)

import Json.Encode exposing (Value, bool, int, list, object, string)


port sendState : Value -> Cmd msg


port sendError : String -> Cmd msg


port recieveMessage : (Value -> msg) -> Sub msg


sendModel : (model -> Value) -> ( model, Cmd msg ) -> ( model, Cmd msg )
sendModel encoder ( model, cmd ) =
    ( model
    , Cmd.batch
        [ cmd
        , sendState
            (encoder model)
        ]
    )


sendModelIfChanged : (model -> Value) -> model -> ( model, Cmd msg ) -> ( model, Cmd msg )
sendModelIfChanged encoder oldModel ( newModel, cmd ) =
    if oldModel == newModel then
        ( newModel, cmd )

    else
        sendModel encoder ( newModel, cmd )


type Element cmd
    = Element String (List Prop) (List (Event cmd)) (List (Element cmd))


type Event cmd
    = Event String cmd


type Prop
    = StringProp String String
    | IntProp String Int
    | BoolProp String Bool
    | NestedProp String (List Prop)


root : (cmd -> Value) -> List Prop -> List (Event cmd) -> List (Element cmd) -> Value
root cmdEncoder props events children =
    encodeElement cmdEncoder (Element "root" props events children)


encodeElement : (cmd -> Value) -> Element cmd -> Value
encodeElement cmdEncoder (Element kind props events children) =
    object
        [ ( "kind", string kind )
        , ( "props", object (List.map encodeProp props) )
        , ( "events", list (encodeEvent cmdEncoder) events )
        , ( "children", list (encodeElement cmdEncoder) children )
        ]


encodeProp : Prop -> ( String, Value )
encodeProp prop =
    case prop of
        StringProp key val ->
            ( key, string val )

        IntProp key val ->
            ( key, int val )

        BoolProp key val ->
            ( key, bool val )

        NestedProp key val ->
            ( key, object (List.map encodeProp val) )


encodeEvent : (cmd -> Value) -> Event cmd -> Value
encodeEvent cmdEncoder (Event key cmd) =
    object
        [ ( "kind", string key )
        , ( "command", cmdEncoder cmd )
        ]



-- Elements


box =
    Element "box"


form =
    Element "form"


button =
    Element "button"
