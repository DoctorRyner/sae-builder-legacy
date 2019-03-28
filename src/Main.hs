module Main where

import           Config           (config)
import           Locale           (locale)
-- import           System.Environment (getArgs)
import           System.Directory (doesFileExist)

import qualified ArgParser

parseYaml :: String -> IO ()
parseYaml file = pure ()

optionsProcessor :: ArgParser.Options -> IO ()
optionsProcessor options =
         if options.help    then putStrLn locale.helpMsg
    else if options.version then putStrLn $ locale.version ++ config.version
    else case options.file of
        Just file -> putStrLn file
        Nothing   -> do
            let fileEquationsPath = "Equations.yaml"
                fileFormulasPath  = "Formulas.yaml"
            fileEquations <- doesFileExist fileEquationsPath
            fileFormulas  <- doesFileExist fileFormulasPath

            if      fileEquations then parseYaml =<< readFile fileEquationsPath
            else if fileFormulas  then parseYaml =<< readFile fileFormulasPath
            else                       putStrLn ArgParser.howToUse

main :: IO ()
main = do
    args <- ArgParser.parse ["b"]
    case args of
        Right options -> optionsProcessor options
        Left err      -> putStrLn err
