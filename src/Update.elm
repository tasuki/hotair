module Update exposing (Msg(..), update)

import Model exposing (Model, Wind, down, up)


type Msg
    = WindChange (List Wind)
    | Up
    | Down
    | Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        new =
            case msg of
                WindChange windAtHeight ->
                    { model | windAtHeight = windAtHeight }

                Up ->
                    { model | balloon = up model.balloon }

                Down ->
                    { model | balloon = down model.balloon }

                Noop ->
                    model
    in
    ( new, Cmd.none )
