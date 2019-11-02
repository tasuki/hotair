module Update exposing (Msg(..), update)

import Model exposing (Model, Wind, changeHeight)


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
                    -- prepend an illegal wind direction - can't move on the ground
                    { model | windAtHeight = Wind -1 :: windAtHeight }

                Up ->
                    { model | balloon = changeHeight model 1 }

                Down ->
                    { model | balloon = changeHeight model -1 }

                Noop ->
                    model
    in
    ( new, Cmd.none )
