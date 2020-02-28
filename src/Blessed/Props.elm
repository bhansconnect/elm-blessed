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


border =
    NestedProp "border"


leftExact =
    IntProp "left"


rightExact =
    IntProp "right"


widthExact =
    IntProp "width"


heightExact =
    IntProp "height"
