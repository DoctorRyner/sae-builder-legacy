module Types where

data Flag
    = Version
    | Async
    | File String
    deriving Show

data Options = Options
    { version
    , async      :: Bool
    , targetFile :: FilePath
    }

defaultOptions :: Options
defaultOptions = Options
    { version    = False
    , async      = False
    , targetFile = "Eq.yml"
    }