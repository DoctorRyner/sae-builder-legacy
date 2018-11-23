{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

-- build tool with additional haskell support

module Main where

import Data.Yaml
import Impure (maybeReadFileBS)
import System.Process (callCommand)
import qualified Data 
import System.Environment
import Data.ByteString.Char8 (ByteString)
import qualified Data.Text as Text
import qualified Data.HashMap.Strict as M

-- execs one formula (task) from equations (file)
solve :: Object -> String -> IO ()
solve equationsHash formula = case maybeCmdValue of
    Just (String cmd) -> case formula of
        "default" -> case M.lookup cmd equationsHash of
            Just (String defaultCmd) -> callCommand $ "solve" ++ Text.unpack defaultCmd
            Nothing -> putStrLn $ Data.formulaNameError ++ " '" ++ formula ++ "'"

        "version" -> putStrLn "0.1"

        _ -> callCommand $ Text.unpack cmd

    Nothing -> do
        putStrLn formula
        putStrLn $ Data.formulaNameError ++ " '" ++ formula ++ "'"

  where maybeCmdValue = M.lookup (Text.pack formula) equationsHash

-- parse file as .yaml
yamlParse :: ByteString -> String -> IO ()
yamlParse equations formula = do
    let equationsContent = decodeEither' equations :: Either ParseException Value

    case equationsContent of
        Right (Object equationsHash) -> solve equationsHash formula

        Right (_) -> putStrLn "Warning! While parcing yaml file I didn't got HashMap"

        Left _ -> putStrLn "Error! YAML file isn't correct and may have errors"

main :: IO ()
main = do
    -- maybe read file with name placed at Data.fileToSolve (probably it's Equations.yaml)
    -- as a ByteString and call it maybeEquations
    -- afterwards takes build tool arguments
    maybeEquations <- maybeReadFileBS Data.fileToSolve
    args <- getArgs

    case maybeEquations of
        Just equations -> case length args of
            -- if no arguments provided then exeutes default formula (task)
            0 -> yamlParse equations Data.defaultEquation
            -- if only 1 argument provided then executes this formula in case if it exests
            1 -> yamlParse equations $ head args
            _ -> putStrLn Data.argsError

        Nothing -> putStrLn Data.fileToSolveError