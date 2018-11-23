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

-- solve :: String -> IO ()
-- solve formula 

-- execs one formula (task) from equations (file)
solve :: ByteString -> String -> IO ()
solve equations formula = do
    -- parse file as .yaml
    let equationsContent = decodeEither' equations

    case equationsContent of
        -- if yaml structured right
        Right (Object equationsHash) -> do
            -- maybe gets value from key (fromula) from HashMap
            let maybeCmdValue = M.lookup (Text.pack formula) equationsHash
                -- testa = Value 

            case maybeCmdValue of
                -- just executes plain command if got 
                Just (String cmd) -> case cmd of
                    "default" ->
                        callCommand $ Text.unpack cmd
                    _ -> callCommand $ Text.unpack cmd
                -- error if could find such a formula in file
                Nothing -> putStrLn $ "There is no such a formula as '" ++ formula ++ "'"

        -- if yaml structured wrong
        Right (_) -> putStrLn "Warning! While parcing yaml file I didn't got HashMap"

        -- if could't parse yaml
        Left _ -> putStrLn "Error! YAML file isn't correct and may have errors"

main :: IO ()
main = do
    -- maybe read file with name placed at Data.fileToSolve (probably it's Equations.yaml)
    -- as a ByteString and call it maybeEquations
    -- afterwards takes build tool arguments
    maybeEquations <- maybeReadFileBS Data.fileToSolve
    args <- getArgs

    case maybeEquations of
        -- if file exists
        Just equations -> case length args of
            -- if no arguments provided then exeutes default formula (task)
            0 -> solve equations Data.defaultEquation
            -- if only 1 argument provided then executes this formula in case if it exests
            1 -> solve equations $ head args
            _ -> putStrLn Data.argsError

        -- if there is no file, say that there is no file
        Nothing -> putStrLn Data.fileToSolveError