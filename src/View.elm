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


type alias Board msg =
    Grid.Grid (Element msg)


cell : Element msg -> Element msg
cell e =
    row [ height (fillPortion 1), width (fillPortion 1) ]
        [ Element.el [ centerX, centerY ] e ]


showRow : Array.Array (Element msg) -> Element msg
showRow r =
    row [ height fill, width fill ]
        (Array.toList r |> List.map cell)


earthPanel : Model -> Element msg
earthPanel model =
    let
        displayTreasures : Int -> Int -> String -> Element msg
        displayTreasures x y e =
            case model.treasures |> Dict.get ( x, y ) of
                Nothing ->
                    Element.el [ Font.color Colors.base00 ] (text ".")

                Just Model.Bronze ->
                    Element.el [ Font.color Colors.red ] (text "1")

                Just Model.Silver ->
                    Element.el [ Font.color Colors.orange ] (text "2")

                Just Model.Gold ->
                    Element.el [ Font.color Colors.yellow ] (text "3")

        setPosition : Model.Player -> Board msg -> Board msg
        setPosition player board =
            Grid.set (Model.toCoordinates player.balloon.position) (displayBalloon player) board

        displayBalloons : List Model.Player -> Board msg -> Board msg
        displayBalloons players board =
            List.foldl setPosition board players

        grid : Board msg
        grid =
            Grid.repeat Model.mapSize Model.mapSize "."
                |> Grid.indexedMap displayTreasures
                |> displayBalloons (model.players |> Dict.values)
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


displayBalloon : Model.Player -> Element msg
displayBalloon player =
    Element.el [ Font.color player.balloon.color ] (text "o")


balloonHeight : Model.Player -> List (Element msg)
balloonHeight player =
    List.range 0 Model.maxHeight
        |> List.reverse
        |> List.map
            (\h ->
                if h == player.balloon.height then
                    displayBalloon player

                else
                    text " "
            )


windsPanel : Model -> Element msg
windsPanel model =
    let
        windsPanelProperties =
            [ height fill
            , width fill
            , Background.color base02
            , padding 20
            , spaceEvenly
            ]

        players : List (Element msg)
        players =
            model.players
                |> Dict.values
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
    layout [ Font.color base3, Background.color base02 ] <|
        row [ Background.color base03, height <| px mapSize, width <| px (mapSize + sidebarWidth), centerX, centerY ]
            [ earthPanel model, windsPanel model ]
