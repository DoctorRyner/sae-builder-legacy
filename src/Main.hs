module Main where

import           Config           (config)
import           Locale           (locale)
-- import           System.Environment (getArgs)
import           System.Directory (doesFileExist)

import qualified ArgParser

parseYaml :: String -> IO ()
parseYaml file = pure ()

optionsProcessor :: (ArgParser.Options, [String]) -> IO ()
optionsProcessor (options, taskNames) =
         if options.help    then putStrLn ArgParser.howToUse
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
main = ArgParser.parse [ "sdf" ] >>= \case
    Right options -> optionsProcessor options
    Left  err     -> putStrLn err
