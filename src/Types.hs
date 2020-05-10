module Types where

import Lens

data Options = Options
    { async
    , showVersion
    , fromMakefile
    , toMakefile   :: Bool
    , targetFile   :: FilePath
    } deriving (Show, Generic)

defaultOptions :: Options
defaultOptions = Options
    { async        = False
    , showVersion  = False
    , fromMakefile = False
    , toMakefile   = False
    , targetFile   = "Eq.yml"
    }