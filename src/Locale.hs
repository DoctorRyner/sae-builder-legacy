module Locale where

data Locale = Locale
    { helpMsg :: String
    }

locale :: Locale
locale = Locale
    { helpMsg = "Just test help message"
    }