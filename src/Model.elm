module Model exposing
    ( Balloon
    , Model
    , Position
    , Wind(..)
    , blow
    , changeHeight
    , emptyModel
    , generatePosition
    , heightField
    , mapSize
    , maxHeight
    , toCoordinates
    )

import Random


type alias Model =
    { windAtHeight : List Wind
    , balloon : Balloon
    , destination : Position
    }


type Wind
    = Calm
    | N Int
    | S Int
    | E Int
    | W Int


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
    10


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


toCoordinates : Position -> ( Int, Int )
toCoordinates position =
    ( position.horizontal, position.vertical )


generatePosition : Random.Generator Position
generatePosition =
    let
        rnd =
            Random.int 0 (mapSize - 1)
    in
    Random.map2 Position rnd rnd


heightField : Random.Generator (List Wind)
heightField =
    let
        windGenerator : Random.Generator Wind
        windGenerator =
            Random.uniform N [ S, E, W ]
                |> Random.map ((|>) 1)

        groundWindPrepender =
            Random.map ((::) Calm)
    in
    Random.list maxHeight windGenerator |> groundWindPrepender


blow : Model -> Balloon
blow model =
    let
        balloon =
            model.balloon

        wind =
            windAtHeight model.windAtHeight model.balloon.height
    in
    { balloon | position = changePosition balloon.position wind }


changePosition : Position -> Wind -> Position
changePosition position wind =
    case wind of
        N _ ->
            { position | vertical = modBy mapSize (position.vertical - 1) }

        S _ ->
            { position | vertical = modBy mapSize (position.vertical + 1) }

        E _ ->
            { position | horizontal = modBy mapSize (position.horizontal + 1) }

        W _ ->
            { position | horizontal = modBy mapSize (position.horizontal - 1) }

        Calm ->
            position


windAtHeight : List Wind -> Int -> Wind
windAtHeight winds height =
    winds
        |> List.drop height
        |> List.head
        |> Maybe.withDefault Calm


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
