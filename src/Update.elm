module Update exposing (Msg(..), update)

import Model exposing (Model, down, up)


type Msg
    = Up
    | Down
    | Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        new =
            case msg of
                Up ->
                    { model | balloon = up model.balloon }

                Down ->
                    { model | balloon = down model.balloon }

                Noop ->
                    model
    in
    ( new, Cmd.none )
