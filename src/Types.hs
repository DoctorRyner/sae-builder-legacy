module Types where

data Flag
    = Version
    | Async
    | File String
    deriving Show

data Options = Options
    { version    :: Bool
    , async      :: Bool
    , targetFile :: FilePath
    }