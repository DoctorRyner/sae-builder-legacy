module ArgParser where

import           System.Console.GetOpt

data Options = Options
    { help
    , version :: Bool
    }

defaultOptions :: Options
defaultOptions = Options
    { help    = False
    , version = False
    }

options :: [OptDescr (Options -> Options)]
options =
    [ Option ['h', '?'] ["help"   ] (NoArg (\opts -> opts { help    = True })) "show help"
    , Option ['v'     ] ["version"] (NoArg (\opts -> opts { version = True })) "show version"
    ]

parse :: [String] -> IO (Either String Options)
parse argv = case getOpt Permute options argv of
    (o, _, []  ) -> pure . Right $ foldl (flip id) defaultOptions o
    (_, _, errs) -> pure . Left $ concat errs ++ usageInfo "Usage: sae [OPTION...]" options