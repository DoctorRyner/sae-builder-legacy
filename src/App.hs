module App where

import System.Console.GetOpt
import Types
import Data.Maybe
import System.Environment

options :: [OptDescr Flag]
options =
    [ Option ['a'] ["async"  ] (NoArg Async  )      "runs formulas asynchronously"
    , Option ['v'] ["version"] (NoArg Version)      "show version"
    , Option ['f'] ["file"   ] (OptArg file "FILE") "get formulas from file"
    ]

file :: Maybe String -> Flag
file = File . fromMaybe "file"

parseOptions :: [String] -> IO (([Flag], [String]))
parseOptions args =
    case getOpt Permute options args of
        (flags, otherArgs,   []) -> pure (flags, otherArgs)
        (_    ,         _, errs) -> fail $ concat errs ++ "\n" ++ usageInfo header options
  where
    header = "Usage: sae [OPTION...] formulas..."

version :: String
version = "v0.3a"

run :: IO ()
run = do
    args <- getArgs

    (flags, otherArgs) <- parseOptions args

    putStrLn $ concat [ "flags: ", concatMap ((++) " " . show) flags ++ "\n\n"
                      , "otherArgs: ", concatMap (++ " ") otherArgs
                      ]