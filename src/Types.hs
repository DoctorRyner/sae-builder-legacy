module Types where

import Lens

data Options = Options
    { async
    , showVersion :: Bool
    , targetFile  :: FilePath
    } deriving (Show, Generic)

defaultOptions :: Options
defaultOptions = Options
    { async       = False
    , showVersion = False
    , targetFile  = "Eq.yml"
    }