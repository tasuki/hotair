module Update exposing (Msg(..), update)

import Dict exposing (Dict)
import Model exposing (Balloon, Model, Player, Position, Treasures, Wind, blow, changeHeight, setBalloonPosition)
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
                        startingPosition : Position
                        startingPosition =
                            List.head positions |> Model.getPosition

                        assumePosition : String -> Player -> Player
                        assumePosition id plr =
                            { plr | balloon = setBalloonPosition startingPosition plr.balloon }

                        players : Dict String Player
                        players =
                            model.players |> Dict.map assumePosition

                        treasures : Treasures
                        treasures =
                            List.drop 1 positions |> Model.generateTreasures
                    in
                    { model | players = players, treasures = treasures }

                WindChange windAtHeight ->
                    { model | windAtHeight = windAtHeight }

                Up ->
                    changeHeight model "cyan" 1

                Down ->
                    changeHeight model "cyan" -1

                Noop ->
                    model
    in
    ( new, Cmd.none )
