{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Yaml
import Impure (maybeReadFileBS, cmdify)
import qualified Data 
import System.Environment
import Data.ByteString.Char8 (ByteString)
import qualified Data.Text as Text
import qualified Data.HashMap.Strict as M

solve :: ByteString -> String -> IO ()
solve equations formula = do
    let equationsContent = decodeEither' equations

    case equationsContent of
        Right (Object equationsHash) -> do
            let maybeCmdValue = M.lookup (Text.pack formula) equationsHash

            case maybeCmdValue of
                Just (String cmd) -> cmdify $ Text.unpack cmd
                Nothing -> putStrLn $ "There is no such a formula as '" ++ formula ++ "'"
 
        Right (_) -> putStrLn "Warning! While parcing yaml file I didn't got HashMap"

        Left _ -> return ()

main :: IO ()
main = do
    maybeEquations <- maybeReadFileBS Data.fileToSolve
    args <- getArgs

    case maybeEquations of
        Just equations -> case length args of
            0 -> solve equations Data.defaultEquation
            1 -> solve equations $ head args
            _ -> putStrLn Data.argsError

        Nothing -> putStrLn Data.fileToSolveError