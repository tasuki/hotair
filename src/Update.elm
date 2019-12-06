module Update exposing (Msg(..), update)

import Model exposing (Model, Position, Wind, blow, changeHeight)
import Time


type Msg
    = Tick Time.Posix
    | MicroTick Time.Posix
    | SetDestination Position
    | WindChange (List Wind)
    | Up
    | Down
    | Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        new =
            case msg of
                Tick _ ->
                    { model | balloon = blow model, microTime = 0 }

                MicroTick _ ->
                    { model | microTime = model.microTime + 1 }

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
