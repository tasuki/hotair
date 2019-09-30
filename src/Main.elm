module Main exposing (main)

import Browser
import Model exposing (Model, emptyModel)
import Update exposing (Msg, update)
import View


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = Update.update
        , view = \model -> { title = "HotAir", body = [ View.view model ] }
        , subscriptions = \_ -> Sub.none
        }


init : flags -> ( Model, Cmd msg )
init flags =
    ( emptyModel, Cmd.none )
