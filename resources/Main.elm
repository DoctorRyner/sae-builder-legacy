module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Utils exposing (pure)

-- MSG
type Msg = Void
-- MODEL
type alias Model = {}

init : () -> (Model, Cmd Msg)
init _ = pure {}

-- VIEW
view : Model -> Html Msg
view model = div [] []

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    Void -> pure model

-- SUBS
subs : Model -> Sub Msg
subs model = Sub.none

main : Program () Model Msg
main = Browser.element
    { init = init, view = toUnstyled << view, update = update, subscriptions = subs }