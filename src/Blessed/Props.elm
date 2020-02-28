module Blessed.Props exposing (..)

import Blessed exposing (Prop(..))


top =
    StringProp "top"


left =
    StringProp "left"


align =
    StringProp "align"


width =
    StringProp "width"


content =
    StringProp "content"


kind =
    StringProp "type"


fg =
    StringProp "fg"


bg =
    StringProp "bg"


border =
    NestedProp "border"


focus =
    NestedProp "focus"


style =
    NestedProp "style"


leftExact =
    IntProp "left"


rightExact =
    IntProp "right"


widthExact =
    IntProp "width"


heightExact =
    IntProp "height"


keys =
    BoolProp "keys"
