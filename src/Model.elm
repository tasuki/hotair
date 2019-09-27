module Model exposing (Balloon, Model, Position, Wind, down, emptyModel, up)


type alias Model =
    { windAtHeight : List Wind
    , balloon : Balloon
    , destination : Position
    }


type alias Wind =
    { direction : Int
    }


type alias Balloon =
    { position : Position
    , height : Int
    }


type alias Position =
    { horizontal : Int
    , vertical : Int
    }


emptyModel : Model
emptyModel =
    { windAtHeight = []
    , balloon =
        { position =
            { horizontal = 0
            , vertical = 0
            }
        , height = 0
        }
    , destination =
        { horizontal = 10
        , vertical = 10
        }
    }


up : Balloon -> Balloon
up balloon =
    { balloon | height = balloon.height + 1 }


down : Balloon -> Balloon
down balloon =
    { balloon
        | height =
            if balloon.height > 0 then
                balloon.height - 1

            else
                0
    }
