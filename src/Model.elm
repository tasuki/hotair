module Model exposing
    ( Balloon
    , Model
    , Position
    , Wind
    , changeHeight
    , emptyModel
    , generatePosition
    , heightField
    , mapSize
    , maxHeight
    )

import Random


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


mapSize : Int
mapSize =
    30


maxHeight : Int
maxHeight =
    20


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


generatePosition : Random.Generator Position
generatePosition =
    Random.map2 Position (Random.int 0 mapSize) (Random.int 0 mapSize)


heightField : Random.Generator (List Wind)
heightField =
    let
        windGenerator =
            Random.map Wind (Random.int 0 3)

        groundWindPrepender =
            Random.map ((::) (Wind -1))
    in
    Random.list maxHeight windGenerator |> groundWindPrepender


changeHeight : Model -> Int -> Balloon
changeHeight model change =
    let
        balloon =
            model.balloon

        newHeight =
            balloon.height + change

        shouldChangeHeight =
            newHeight >= 0 && newHeight <= maxHeight
    in
    { balloon
        | height =
            if shouldChangeHeight then
                newHeight

            else
                balloon.height
    }
