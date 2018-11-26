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
import Control.Concurrent.Async
import qualified Data.Text as Text
import qualified Data.HashMap.Strict as M

solveAll :: Object -> [String] -> (Maybe String, [String])
solveAll equationsHash gottenFormulas = solve gottenFormulas []
  where 
    solve :: [String] -> [String] -> (Maybe String, [String])
    solve formulas solvedFormulas
        | length formulas > 0 = do
            let headFormula   = Text.pack $ head formulas
                maybeCmdValue = M.lookup headFormula equationsHash

            case maybeCmdValue of
                -- to do all types, not just string value
                Just (String cmd) -> solve (tail formulas) $ solvedFormulas ++ [ Text.unpack cmd ]
                Nothing           -> (Just $ "There is no formula named " ++ Text.unpack headFormula, [])
        | otherwise = (Nothing, solvedFormulas)

--     case formula of
--     _ -> case maybeCmdValue of
--         Just (String cmd) -> callCommand $ Text.unpack cmd
--         Nothing -> putStrLn $ Data.formulaNameError ++ " '" ++ formula ++ "'"

--   where maybeCmdValue = M.lookup (Text.pack formula) equationsHash

-- execs one formula (task) from equations (file)
-- solveOne :: Object -> String -> IO ()
-- solveOne equationsHash formula = case formula of
--     "help"   -> putStrLn Data.help
--     "--help" -> putStrLn Data.help

--     _ -> case maybeCmdValue of
--         Just (String cmd) -> callCommand $ Text.unpack cmd
--         Nothing -> putStrLn $ Data.formulaNameError ++ " '" ++ formula ++ "'"

--   where maybeCmdValue = M.lookup (Text.pack formula) equationsHash
 
-- decode and parsing .yaml file
yamlParse :: ByteString -> [String] -> IO ()
yamlParse equations formulas = do
    let equationsContent = decodeEither' equations
 
    case equationsContent of
        Right (Object equationsHash) -> do
            let maybeSolvedFormulas = solveAll equationsHash formulas

            case maybeSolvedFormulas of
                (Nothing, solvedFormulas) ->
                    concurrently_ (putStrLn "")
                        (foldr (\callCmd allCalls -> allCalls >>= callCmd) (return ()) $
                            map (\solvedFormula -> \_ -> callCommand solvedFormula) solvedFormulas)

                (Just errorText, _) -> putStrLn $ Data.formulaNameError ++ errorText

        Right (_) -> putStrLn Data.yamlParseError

        Left _ -> putStrLn Data.yamlIncorrectStructureError




main :: IO ()
main = do
    -- maybe read file with name placed at Data.fileToSolve (probably it's Equations.yaml)
    -- as a ByteString and call it maybeEquations
    -- afterwards takes build tool arguments
    maybeEquations <- maybeReadFileBS Data.fileToSolve
    args           <- getArgs

    case maybeEquations of
        Just equations -> case length args of
            -- if no arguments provided then exeutes default formula (task)
            0 -> yamlParse equations [ Data.defaultEquation ]
            -- if only 1 argument provided then executes this formula in case if it exests
            1 -> yamlParse equations [ head args ]
            _ -> case head $ head args of
                '!' -> putStrLn "kek"
                _   -> yamlParse equations args
                    -- putStrLn Data.argsError

        Nothing -> putStrLn Data.fileToSolveError