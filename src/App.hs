module App where

import Control.Monad
import System.Console.GetOpt
import Types
import Data.Maybe
import System.Environment
import Lens
import Data.Yaml

options :: [OptDescr (Options -> Options)]
options =
    [ Option ['a'] ["async"  ] (NoArg  (\opts -> opts { async       = True })) "async stuff"
    , Option ['v'] ["version"] (NoArg  (\opts -> opts { showVersion = True })) "version stuff"
    , Option ['f'] ["file"   ]
        (OptArg ((\f opts -> opts { targetFile = f }) . fromMaybe "FILE") "" ) "file stuff"
    ]

parseOptions :: [String] -> IO (Options, [String])
parseOptions argv =
    case getOpt Permute options argv of
        (flags, otherArgs,   []) -> pure (foldl (flip id) defaultOptions flags, otherArgs)
        (_    , _        , errs) -> fail $ concat errs ++ usageInfo header options
  where header = "Usage: sae [OPTION...] formulas..."

version :: String
version = "current version v0.3b"

run :: IO ()
run = do
    args <- getArgs

    (opts, formulas) <- parseOptions args

    when (opts ^. #showVersion) $ putStrLn version

    file :: Value <- decodeFileThrow $ opts ^. #targetFile

    print file

    print opts