module App where

import Prelude hiding (putStrLn)
import CLI.Colored (putStrLn)

import System.Console.GetOpt
import Types
import System.Environment

import Cli.Options as Options
import Handler

parseOptions :: [String] -> IO (Options, [String])
parseOptions argv =
    case getOpt Permute options argv of
        (flags, otherArgs,   []) -> pure (foldl (flip id) defaultOptions flags, otherArgs)
        (_    , _        , errs) -> fail $ concat errs ++ usageInfo Options.header options

run :: IO ()
run = do
    args <- getArgs

    (opts, _formulas) <- parseOptions args

    -- file :: Value <- decodeFileThrow $ opts ^. #targetFile

    putStrLn "#green(Running SAE ...)"

    handler opts