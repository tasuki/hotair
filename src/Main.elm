module Main exposing (main)

import Browser
import Browser.Events exposing (onKeyDown)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Model exposing (Model, emptyModel)
import Update exposing (Msg(..), update)
import View


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = Update.update
        , view = \model -> { title = "HotAir", body = [ View.view model ] }
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd msg )
init () =
    ( emptyModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onKeyDown (Decode.map key keyCode)
        ]


key : Int -> Msg
key keycode =
    case keycode of
        38 ->
            Up

        40 ->
            Down

        _ ->
            Noop
