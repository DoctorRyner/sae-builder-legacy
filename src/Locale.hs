module Locale where

data Locale = Locale
    { helpMsg
    , version :: String
    }

locale :: Locale
locale = Locale
    { helpMsg = "Just test help message"
    , version = "sae (Solver Of All Equations)\nversion "
    }