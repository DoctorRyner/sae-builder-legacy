module Types where

data Flag
    = Version
    | Async
    | File String
    deriving Show

data Options = Options
    { async
    , showVersion :: Bool
    , targetFile  :: FilePath
    }

defaultOptions :: Options
defaultOptions = Options
    { async       = False
    , showVersion = False
    , targetFile  = "Eq.yml"
    }