module Config where

data Config = Config
    { version :: String
    }

config :: Config
config = Config
    { version = "0.1a"
    }