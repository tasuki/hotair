module Update exposing (Msg(..), update)

import Model exposing (Model, Position, Treasures, Wind, blow, changeHeight, setBalloonPosition)
import Time


type Msg
    = Tick Time.Posix
    | AssumePositions (List Position)
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
                    blow model

                AssumePositions positions ->
                    let
                        balloonPosition : Position
                        balloonPosition =
                            List.head positions |> Model.getPosition

                        treasures : Treasures
                        treasures =
                            List.drop 1 positions |> Model.generateTreasures
                    in
                    { model | balloon = setBalloonPosition model.balloon balloonPosition, treasures = treasures }

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
