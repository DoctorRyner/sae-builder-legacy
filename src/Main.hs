module Main where

import           Config      (config)
import           Locale      (locale)
-- import           System.Environment (getArgs)

import qualified ArgParser

optionsProcessor :: ArgParser.Options -> IO ()
optionsProcessor options =
         if options.help    then putStrLn locale.helpMsg
    else if options.version then
        putStrLn $ "sae (Solver Of All Equations)\nversion " ++ config.version
    else putStrLn locale.helpMsg

main :: IO ()
main = do
    args <- ArgParser.parse ["?", "mdaka", "--help"]
    case args of
        Right options -> optionsProcessor options
        Left err                -> putStrLn err
