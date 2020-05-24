module App where

import Prelude hiding (putStrLn)
import CLI.Colored (putStrLn)

import System.Console.GetOpt
import Types
import System.Environment

import Cli.Options as Options
import Handler
import Data.Yaml
import Lens
import qualified Data.Text as T

parseOptions :: [String] -> IO (Options, [T.Text])
parseOptions argv =
    case getOpt Permute options argv of
        (flags, otherArgs,   []) -> pure (foldl (flip id) defaultOptions flags, T.pack <$> otherArgs)
        (_    , _        , errs) -> fail $ concat errs ++ usageInfo Options.header options

run :: IO ()
run = do
    args <- getArgs

    (opts, formulas) <- parseOptions args

    file :: Value <- decodeFileThrow $ opts ^. #targetFile

    print file

    putStrLn "#green(Running SAE ...)"

    handler opts file formulas