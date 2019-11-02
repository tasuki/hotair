module Model exposing
    ( Balloon
    , Model
    , Position
    , Wind
    , changeHeight
    , emptyModel
    , heightField
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


heightField : Random.Generator (List Wind)
heightField =
    Random.list maxHeight (Random.map (\d -> Wind d) (Random.int 0 3))


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
