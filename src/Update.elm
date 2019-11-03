module Update exposing (Msg(..), update)

import Model exposing (Model, Position, Wind, changeHeight)


type Msg
    = SetDestination Position
    | WindChange (List Wind)
    | Up
    | Down
    | Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        new =
            case msg of
                SetDestination position ->
                    { model | destination = position }

                WindChange windAtHeight ->
                    { model | windAtHeight = windAtHeight }

                Up ->
                    { model | balloon = changeHeight model 1 }

                Down ->
                    { model | balloon = changeHeight model -1 }

                Noop ->
                    model
    in
    ( new, Cmd.none )
