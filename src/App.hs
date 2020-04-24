module App where

import System.Console.GetOpt
import Types
import Data.Maybe

options :: [OptDescr Flag]
options =
    [ Option ['a'] ["async"  ] (NoArg Async  )      "runs formulas asynchronously"
    , Option ['v'] ["version"] (NoArg Version)      "show version"
    , Option ['f'] ["file"   ] (OptArg file "FILE") "get formulas from file"
    ]

file :: Maybe String -> Flag
file = File . fromMaybe "file"