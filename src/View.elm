module View exposing (view)

import Array
import Colors exposing (..)
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Grid
import Html exposing (Html)
import Model exposing (Model)
import Update exposing (Msg(..))


sidebarWidth =
    90


mapSize =
    400


type alias Board =
    Grid.Grid String


cell : String -> Element msg
cell str =
    row [ height (fillPortion 1), width (fillPortion 1) ]
        [ Element.el [ centerX, centerY ] (text str) ]


showRow : Array.Array String -> Element msg
showRow r =
    row [ height fill, width fill ]
        (Array.toList r |> List.map cell)


earthPanel : Model -> Element msg
earthPanel model =
    let
        displayTreasures : Int -> Int -> String -> String
        displayTreasures x y e =
            case model.treasures |> Dict.get ( x, y ) of
                Nothing ->
                    "."

                Just Model.Bronze ->
                    "1"

                Just Model.Silver ->
                    "2"

                Just Model.Gold ->
                    "3"

        setPosition : Model.Balloon -> Board -> Board
        setPosition balloon board =
            Grid.set (Model.toCoordinates balloon.position) "o" board

        displayBalloons : List Model.Balloon -> Board -> Board
        displayBalloons balloons board =
            List.foldl setPosition board balloons

        grid : Board
        grid =
            Grid.repeat Model.mapSize Model.mapSize "."
                |> Grid.indexedMap displayTreasures
                |> displayBalloons (model.players |> List.map (\p -> p.balloon))
    in
    Grid.rows grid
        |> Array.map showRow
        |> Array.toList
        |> column [ height fill, width fill ]


displayDirection : Model.Wind -> String
displayDirection direction =
    case direction of
        Model.N _ ->
            "^"

        Model.S _ ->
            "v"

        Model.E _ ->
            ">"

        Model.W _ ->
            "<"

        Model.Calm ->
            " "


windList : List Model.Wind -> List (Element msg)
windList windAtHeight =
    windAtHeight
        |> List.reverse
        |> List.map (\w -> el [ alignRight ] (text <| displayDirection w))


balloonHeight : Model.Player -> List (Element msg)
balloonHeight player =
    List.range 0 Model.maxHeight
        |> List.reverse
        |> List.map
            (\h ->
                if h == player.balloon.height then
                    "o"

                else
                    " "
            )
        |> List.map text


windsPanel : Model -> Element msg
windsPanel model =
    let
        windsPanelProperties =
            [ height fill
            , width fill
            , Background.color base01
            , padding 20
            , spaceEvenly
            ]

        players : List (Element msg)
        players =
            model.players
                |> List.map balloonHeight
                |> List.map (column windsPanelProperties)

        legend : Element msg
        legend =
            column windsPanelProperties (windList model.windAtHeight)
    in
    row [ height fill, width <| px sidebarWidth ]
        (List.append players [ legend ])


view : Model -> Html Msg
view model =
    layout [ Font.color base3, Background.color base03 ] <|
        row [ Background.color base02, height <| px mapSize, width <| px (mapSize + sidebarWidth), centerX, centerY ]
            [ earthPanel model, windsPanel model ]
