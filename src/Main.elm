module Main exposing (main)

import Browser
import Browser.Events
import Json.Decode as D
import Model exposing (Model)
import Update exposing (Msg(..))
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
    ( Model.emptyModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onKeyDown (D.map key (D.field "key" D.string))
        ]


key : String -> Msg
key keycode =
    case keycode of
        "ArrowUp" ->
            Up

        "ArrowDown" ->
            Down

        _ ->
            Noop
