module Model exposing
    ( Balloon
    , Model
    , Player
    , Position
    , Treasure(..)
    , Treasures
    , Wind(..)
    , allPositions
    , blow
    , changeHeight
    , emptyModel
    , generateTreasures
    , getPosition
    , heightField
    , mapSize
    , maxHeight
    , setBalloonPosition
    , toCoordinates
    )

import Colors
import Dict exposing (Dict)
import Element
import Random


type alias Model =
    { windAtHeight : List Wind
    , players : Dict String Player
    , treasures : Treasures
    }


type Wind
    = Calm
    | N Int
    | S Int
    | E Int
    | W Int


type alias Player =
    { name : String
    , balloon : Balloon
    , score : Int
    }


type alias Balloon =
    { color : Element.Color
    , position : Position
    , height : Int
    , changedHeight : Bool
    }


type alias Treasures =
    -- Should be `Dict Position Treasure`. Records aren't comparable. Tuples are. Go figure.
    Dict ( Int, Int ) Treasure


type Treasure
    = Bronze
    | Silver
    | Gold


type alias Position =
    { horizontal : Int
    , vertical : Int
    }


mapSize : Int
mapSize =
    12


maxHeight : Int
maxHeight =
    10


availableTreasures : List Treasure
availableTreasures =
    [ Gold, Gold, Gold, Silver, Silver, Silver, Bronze, Bronze, Bronze ]


treasureValue : Treasure -> Int
treasureValue treasure =
    case treasure of
        Gold ->
            3

        Silver ->
            2

        Bronze ->
            1


generateTreasures : List Position -> Treasures
generateTreasures positions =
    let
        zipped : List ( ( Int, Int ), Treasure )
        zipped =
            List.map2 Tuple.pair (positions |> List.map toCoordinates) availableTreasures
    in
    Dict.fromList zipped


createPlayer : String -> Element.Color -> ( String, Player )
createPlayer name col =
    let
        balloon =
            { color = col
            , position =
                { horizontal = 0
                , vertical = 0
                }
            , height = 0
            , changedHeight = False
            }

        player =
            { name = name
            , balloon = balloon
            , score = 0
            }
    in
    ( name, player )


emptyModel : Model
emptyModel =
    { windAtHeight = []
    , players =
        Dict.fromList
            [ createPlayer "player1" Colors.cyan
            , createPlayer "player2" Colors.blue
            ]
    , treasures = Dict.empty
    }


toCoordinates : Position -> ( Int, Int )
toCoordinates position =
    ( position.horizontal, position.vertical )


getPosition : Maybe Position -> Position
getPosition position =
    Maybe.withDefault (Position 0 0) position


allPositions : List Position
allPositions =
    let
        coordsList =
            List.range 0 (mapSize - 1)

        createPositionRow : Int -> List Position
        createPositionRow row =
            coordsList |> List.map (Position row)
    in
    coordsList |> List.concatMap createPositionRow


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


setBalloonPosition : Position -> Balloon -> Balloon
setBalloonPosition position balloon =
    { balloon | position = position, changedHeight = False }


blowPlayer : List Wind -> String -> Player -> Player
blowPlayer winds id player =
    let
        playerWind =
            windAtHeight winds player.balloon.height

        position =
            changePosition player.balloon.position playerWind
    in
    { player | balloon = setBalloonPosition position player.balloon }


blow : Model -> Model
blow model =
    { model | players = model.players |> Dict.map (blowPlayer model.windAtHeight) }


updatePositionNoWrap : Int -> Int -> Int
updatePositionNoWrap position move =
    let
        newPosition =
            position + move
    in
    if newPosition >= 0 && newPosition < mapSize then
        newPosition

    else
        position


updatePositionWrap : Int -> Int -> Int
updatePositionWrap position move =
    modBy mapSize (position + move)


changePosition : Position -> Wind -> Position
changePosition position wind =
    let
        updateFunction =
            updatePositionNoWrap
    in
    case wind of
        N _ ->
            { position | vertical = updateFunction position.vertical -1 }

        S _ ->
            { position | vertical = updateFunction position.vertical 1 }

        E _ ->
            { position | horizontal = updateFunction position.horizontal 1 }

        W _ ->
            { position | horizontal = updateFunction position.horizontal -1 }

        Calm ->
            position


windAtHeight : List Wind -> Int -> Wind
windAtHeight winds height =
    winds
        |> List.drop height
        |> List.head
        |> Maybe.withDefault Calm


changeBalloonHeight : Balloon -> Int -> Balloon
changeBalloonHeight balloon change =
    let
        newHeight =
            balloon.height + change

        shouldChangeHeight =
            balloon.changedHeight == False && newHeight >= 0 && newHeight <= maxHeight
    in
    { balloon
        | height =
            if shouldChangeHeight then
                newHeight

            else
                balloon.height
        , changedHeight = True
    }


changeHeight : Model -> String -> Int -> Model
changeHeight model id change =
    let
        maybeTreasure : Player -> Maybe Treasure
        maybeTreasure player =
            Dict.get (toCoordinates player.balloon.position) model.treasures

        takesTreasure : Player -> Maybe Player
        takesTreasure player =
            if player.balloon.height == 0 then
                Just player

            else
                Nothing

        collected : Player -> Int
        collected player =
            takesTreasure player
                |> Maybe.andThen maybeTreasure
                |> Maybe.map treasureValue
                |> Maybe.withDefault 0

        changePlayerHeight : Player -> Player
        changePlayerHeight player =
            let
                new =
                    { player | balloon = changeBalloonHeight player.balloon change }
            in
            { new | score = new.score + collected new }

        newPlayers : Dict String Player
        newPlayers =
            Dict.update id (Maybe.map changePlayerHeight) model.players

        removeTreasure : Player -> Treasures
        removeTreasure player =
            Dict.remove (toCoordinates player.balloon.position) model.treasures

        takeTreasure : Player -> Maybe Treasures
        takeTreasure player =
            Maybe.map removeTreasure (takesTreasure player)

        newTreasures : Treasures
        newTreasures =
            Dict.get id newPlayers
                |> Maybe.andThen takeTreasure
                |> Maybe.withDefault model.treasures
    in
    { model | players = newPlayers, treasures = newTreasures }
