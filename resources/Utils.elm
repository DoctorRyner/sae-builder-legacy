module Utils exposing (..)

pure : a -> (a, Cmd b)
pure a = (a, Cmd.none)