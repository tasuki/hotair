module View exposing (view)

import Array
import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Grid
import Html exposing (Html)
import Model exposing (Model)
import Update exposing (Msg(..))


sidebarWidth =
    110


topbarHeight =
    10


mapSize =
    400


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
        grid : Grid.Grid String
        grid =
            Grid.repeat Model.mapSize Model.mapSize "."
                |> Grid.set (Model.toCoordinates model.destination) "x"
                |> Grid.set (Model.toCoordinates model.balloon.position) "o"
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


balloonHeight : Model.Balloon -> List (Element msg)
balloonHeight balloon =
    List.range 0 Model.maxHeight
        |> List.reverse
        |> List.map
            (\h ->
                if h == balloon.height then
                    "o"

                else
                    " "
            )
        |> List.map (\t -> text t)


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
    in
    row [ height fill, width <| px sidebarWidth ]
        [ column windsPanelProperties (balloonHeight model.balloon)
        , column windsPanelProperties (windList model.windAtHeight)
        ]


progressBar : Model -> Element msg
progressBar model =
    let
        bar =
            List.range 1 (Model.progressbarSize + 1)
                |> List.map
                    (\i ->
                        if i <= model.microTime then
                            "x"

                        else
                            " "
                    )
                |> List.map (\i -> el [ width fill ] (text i))
    in
    row [ width fill ] bar


view : Model -> Html Msg
view model =
    layout [ Font.color base3, Background.color base03 ] <|
        column [ Background.color base02, height <| px (mapSize + topbarHeight), centerX, centerY ]
            [ row [ width fill ] [ el [ width fill ] (progressBar model) ]
            , row [ Background.color base02, height <| px mapSize, width <| px (mapSize + sidebarWidth), centerX, centerY ]
                [ earthPanel model, windsPanel model ]
            ]
