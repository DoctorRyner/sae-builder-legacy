module Cli.Options where

import System.Console.GetOpt
import Types
import Data.Maybe

options :: [OptDescr (Options -> Options)]
options =
    [ Option ['a'] ["async"]
        (NoArg (\opts -> opts { async = True })) "runs formulas asynchronously"
    , Option ['v'] ["version"]
        (NoArg (\opts -> opts { showVersion = True })) "show version"
    , Option [   ] ["toMakefile"]
        (NoArg (\opts -> opts { toMakefile = True })) "converst Eq file to Makefile"
    , Option [   ] ["fromMakefile"]
        (NoArg (\opts -> opts { fromMakefile = True })) "converst Makefile to Eq file"
    , Option ['f'] ["file"]
        (OptArg ((\f opts -> opts { targetFile = f }) . fromMaybe "FILE") "" ) "get formulas from file"
    ]

header :: String
header = "Usage: sae [OPTION...] formulas..."