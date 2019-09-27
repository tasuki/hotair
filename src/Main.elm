module Main exposing (main)

import Browser
import Model exposing (Model, emptyModel)
import Update exposing (Msg, update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = Update.update
        , view = View.view

        -- , subscriptions = \_ -> Sub.none
        }


init : Model
init =
    emptyModel
