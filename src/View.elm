module View exposing (view)

import Html exposing (Html, div, text)
import Model exposing (Model)
import Update exposing (Msg(..))


windList windAtHeight =
    String.join ", " (List.map (\w -> String.fromInt w.direction) windAtHeight)


view : Model -> Html Msg
view model =
    div []
        [ text (String.fromInt model.balloon.height)
        , div []
            [ text (windList model.windAtHeight) ]
        ]
