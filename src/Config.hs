module Config where

import Lens

newtype Config = Config
    { version :: String
    } deriving Generic

config :: Config
config = Config
    { version = "v0.3b"
    }