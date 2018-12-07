module Main where

import qualified Data
import qualified Data.Text as Text
import qualified Data.HashMap.Strict as HashMap
import qualified Data.Vector as Vector
import Data.Yaml (Object, Value(..), decodeEither')
import Data.Yaml.Aeson (Array)
import Data.Maybe (fromMaybe, fromJust)
import System.Environment (getArgs)
import Data.ByteString.Char8 (ByteString)
import Control.Concurrent.Async (mapConcurrently_)
import Impure (maybeFileBS, exitIfCmdIsNotValid)
import Regex.Parser (replace)
import System.Exit (die)

-- returns either list of solved formulas, either problem formula name
solveAll :: Object -> [String] -> (Maybe String, [String])
solveAll equationsHash gottenFormulas = solve gottenFormulas []
  where 
    solve :: [String] -> [String] -> (Maybe String, [String])
    solve formulas solvedFormulas
        | length formulas > 0 = do
            let headFormula        = Text.pack $ head formulas 
                maybeSolvedFormula = HashMap.lookup headFormula equationsHash

            case maybeSolvedFormula of
                -- to do all types, not just string value
                Just (String solvedFormula) -> solve (tail formulas) $ solvedFormulas ++ [ Text.unpack solvedFormula ]
                Nothing                     -> (Just $ Text.unpack headFormula, [])
                _                           -> (Just $ Text.unpack headFormula ++ Data.wrongFormulaTypeError, [])
        | otherwise = (Nothing, solvedFormulas)

resolveLets :: Array -> (Maybe String, HashMap.HashMap Text.Text String)
resolveLets gottenLets = resolve gottenLets HashMap.empty
  where
    resolve :: Array -> HashMap.HashMap Text.Text String -> (Maybe String, HashMap.HashMap Text.Text String)
    resolve lets resolvedLets
        | length lets > 0 = do
            let headLet = Vector.head lets
            case headLet of
                Object val -> do
                    let list = HashMap.toList val
                    if length list == 1
                        then case head list of
                            (key, value) -> case value of
                                String str -> resolve (Vector.tail lets) $
                                    HashMap.insert key (Text.unpack str) resolvedLets
                                _ -> (Just $ Text.unpack key ++ Data.constTypeError, HashMap.empty)

                        else (Just Data.letsStructureError, HashMap.empty)

                _ -> (Just Data.letsStructureError, HashMap.empty)
        | otherwise = (Nothing, resolvedLets)

replaceLets :: [Text.Text] -> String -> HashMap.HashMap Text.Text String -> String
replaceLets letNames formula lets = foldr
    (\letName out -> do
        let maybeFormulaValue = HashMap.lookup (Text.pack letName) lets
        case maybeFormulaValue of
            Just parsedFormula -> replace ("@" ++ letName ++ "\\?") out parsedFormula
            Nothing            -> "ERROR"
    ) formula $ map Text.unpack letNames

-- decode and parsing .yaml file
yamlParse :: ByteString -> [String] -> Bool -> IO ()
yamlParse equations formulas isAsync = case equationsContent of 
    Right (Object equationsHash) ->
        let maybeLets           = HashMap.lookup (Text.pack "let") equationsHash
            maybeSolvedFormulas = solveAll equationsHash formulas
        in case maybeLets of
            Just lets -> case lets of
                Array letsArray ->
                    let maybeResolvedLets = resolveLets letsArray
                    in case maybeResolvedLets of
                        (Nothing, resolvedLets) ->
                            let letNames = HashMap.keys resolvedLets
                            in case maybeSolvedFormulas of
                                (Nothing, solvedFormulas) ->
                                    let solvedFormulasLetParsed = map (\formula -> replaceLets letNames formula resolvedLets) solvedFormulas

                                    in (if isAsync
                                        then mapConcurrently_
                                        else mapM_)           exitIfCmdIsNotValid solvedFormulasLetParsed
                                (Just unknownFormulaName, _) -> die $
                                    Data.formulaNameError ++ unknownFormulaName

                        (Just errorText, _) -> die errorText

                _ -> die Data.letsStructureError

            Nothing   -> case maybeSolvedFormulas of
                (Nothing, solvedFormulas) ->
                    (if isAsync then mapConcurrently_ else mapM_) exitIfCmdIsNotValid solvedFormulas

                (Just unknownFormulaName, _) -> die $ Data.formulaNameError ++ unknownFormulaName

    Right (_) -> die Data.yamlParseError

    Left _ -> die Data.yamlIncorrectStructureError

  where equationsContent = decodeEither' equations

analyzeCommand :: ByteString -> [String] -> IO ()
analyzeCommand equations args = case length args of
    0 -> yamlParse equations [ Data.defaultEquation ] False

    1 -> case head args of
        "--async" -> die Data.asyncKeyError
        "--help"  -> putStrLn Data.help
        _         -> yamlParse equations [ head args ] False

    _ -> case head args of
        "--async" -> yamlParse equations (tail args) True
        _         -> yamlParse equations args False

main :: IO ()
main = maybeFileBS Data.fileToSolve >>= \file -> getArgs >>= \args ->
    fromMaybe (die Data.fileToSolveError) $ Just $ analyzeCommand (fromJust file) args