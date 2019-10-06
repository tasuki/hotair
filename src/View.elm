module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Update exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ text (String.fromInt model.balloon.height) ]
