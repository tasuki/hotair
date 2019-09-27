module Update exposing (Msg(..), update)

import Model exposing (Model, down, up)


type Msg
    = Up
    | Down


update : Msg -> Model -> Model
update msg model =
    case msg of
        Up ->
            { model | balloon = up model.balloon }

        Down ->
            { model | balloon = down model.balloon }
