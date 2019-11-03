module View exposing (view)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Model exposing (Model)
import Update exposing (Msg(..))


earthPanel : Model -> Element msg
earthPanel model =
    let
        cell =
            row [ height (fillPortion 1), width (fillPortion 1) ] [ text "." ]
    in
    column [ height fill, width fill ]
        (List.repeat Model.mapSize
            (row [ height fill, width fill ]
                (List.repeat Model.mapSize cell)
            )
        )



-- [ text (String.fromInt model.balloon.height)
-- , text (String.fromInt model.destination.horizontal)
-- , text (String.fromInt model.destination.vertical)
-- ]


displayDirection : Int -> String
displayDirection direction =
    case direction of
        0 ->
            "^"

        1 ->
            ">"

        2 ->
            "v"

        3 ->
            "<"

        _ ->
            " "


windList : List Model.Wind -> List (Element msg)
windList windAtHeight =
    windAtHeight
        |> List.reverse
        |> List.map (\w -> el [ alignRight ] (text <| displayDirection w.direction))


balloonHeight : Model.Balloon -> List (Element msg)
balloonHeight balloon =
    List.range 0 Model.maxHeight
        |> List.reverse
        |> List.map
            (\h ->
                if h == balloon.height then
                    "x"

                else
                    " "
            )
        |> List.map (\t -> text t)


windsPanel : Model -> Element msg
windsPanel model =
    let
        windsPanelProperties =
            [ height fill
            , width <| shrink
            , Background.color base0
            , padding 20
            , spaceEvenly
            ]
    in
    row [ height fill ]
        [ column windsPanelProperties (balloonHeight model.balloon)
        , column windsPanelProperties (windList model.windAtHeight)
        ]


view : Model -> Html Msg
view model =
    layout [ Font.color base3, Background.color base03 ] <|
        row [ height fill, width fill ]
            [ earthPanel model, windsPanel model ]
