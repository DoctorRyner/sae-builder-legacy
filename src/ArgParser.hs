module ArgParser where

import           System.Console.GetOpt

howToUse :: String
howToUse = usageInfo
     "sae (Solver Of All Equations) — the building tool\n\n\
    \Usage: sae [OPTION...]\n" options

data Options = Options
    { help
    , version :: Bool
    , file    :: Maybe FilePath
    }

defaultOptions :: Options
defaultOptions = Options
    { help    = False
    , version = False
    , file    = Nothing
    }

options :: [OptDescr (Options -> Options)]
options =
    [ Option ['h', '?'] ["help"   ] (NoArg (\opts -> opts { help    = True })) "show help"
    , Option ['v'     ] ["version"] (NoArg (\opts -> opts { version = True })) "show version"
    , Option ['f'     ] ["file"   ]
        (OptArg ((\ filePath opts -> opts { file = filePath }) ) "FILE") "source FILE"
    ]

parse :: [String] -> IO (Either String Options)
parse argv = case getOpt Permute options argv of
    (o, n, []  ) -> do
        putStrLn $ concat n
        pure . Right $ foldl (flip id) defaultOptions o
    (_, _, errs) -> pure . Left  $ concat errs ++ howToUse