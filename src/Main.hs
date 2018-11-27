module Main where

import qualified Data
import qualified Data.Text as Text
import qualified Data.HashMap.Strict as M
import Data.Yaml (Object, Value(..), decodeEither')
import System.Process (callCommand)
import System.Environment (getArgs)
import Data.ByteString.Char8 (ByteString)
import Control.Concurrent.Async (mapConcurrently_)
import Impure (maybeReadFileBS)

-- returns either list of solved formulas, either problem formula name
solveAll :: Object -> [String] -> (Maybe String, [String])
solveAll equationsHash gottenFormulas = solve gottenFormulas []
  where 
    solve :: [String] -> [String] -> (Maybe String, [String])
    solve formulas solvedFormulas
        | length formulas > 0 = do
            let headFormula        = Text.pack $ head formulas
                maybeSolvedFormula = M.lookup headFormula equationsHash

            case maybeSolvedFormula of
                -- to do all types, not just string value
                Just (String solvedFormula) -> solve (tail formulas) $ solvedFormulas ++ [ Text.unpack solvedFormula ]
                Nothing                     -> (Just $ Text.unpack headFormula, [])
        | otherwise = (Nothing, solvedFormulas)
 
-- decode and parsing .yaml file
yamlParse :: ByteString -> [String] -> Bool -> IO ()
yamlParse equations formulas isAsync = do
    let equationsContent = decodeEither' equations
 
    case equationsContent of
        Right (Object equationsHash) -> do
            let maybeSolvedFormulas = solveAll equationsHash formulas
 
            case maybeSolvedFormulas of
                (Nothing, solvedFormulas) ->
                    (if isAsync then mapConcurrently_ else mapM_) callCommand solvedFormulas

                (Just unknownFormulaName, _) -> putStrLn $ Data.formulaNameError ++ unknownFormulaName

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
            0 -> yamlParse equations [ Data.defaultEquation ] False
            -- if only 1 argument provided then executes this formula in case if it exests
            1 -> case head args of
                "--async" -> putStrLn Data.asyncKeyError
                "--help"  -> putStrLn Data.help
                _         -> yamlParse equations [ head args ] False
            _ -> case head args of
                "--async" -> yamlParse equations (tail args) True
                _         -> yamlParse equations args False

        Nothing -> putStrLn Data.fileToSolveError