module Main where

import qualified Data
import Data.Text (Text, pack, unpack)
import qualified Data.Vector as Vector
import qualified Data.HashMap.Strict as HashMap
import Data.HashMap.Strict (HashMap)
import Data.Yaml (Object, Value(..), decodeEither')
import Data.Yaml.Aeson (Array)
import Data.Maybe (fromMaybe, fromJust)
import System.Environment (getArgs)
import Data.ByteString.Char8 (ByteString)
import Control.Concurrent.Async (mapConcurrently_)
import Impure (maybeFileBS, exitIfCmdIsNotValid)
import Regex.Parser (replace)
import System.Exit (die)

solveAll :: Object -> [String] -> Either String [String]
solveAll equationsHash gottenFormulas = solve gottenFormulas [] where
    solve :: [String] -> [String] -> Either String [String]
    solve formulas solvedFormulas
        | length formulas > 0 =
            let headFormula        = pack $ head formulas 
                maybeSolvedFormula = HashMap.lookup headFormula equationsHash
            in case maybeSolvedFormula of
                Just (String solvedFormula) -> solve (tail formulas) $ solvedFormulas ++ [ unpack solvedFormula ]
                Nothing                     -> Left $ unpack headFormula
                _                           -> Left $ unpack headFormula ++ Data.wrongFormulaTypeError
        | otherwise = Right solvedFormulas

resolveLets :: Array -> Either String (HashMap Text String)
resolveLets gottenLets = resolve gottenLets HashMap.empty where
    resolve :: Array -> HashMap Text String -> Either String (HashMap Text String)
    resolve lets resolvedLets
        | length lets > 0 = case Vector.head lets of
            Object val ->
                let list = HashMap.toList val in
                if length list == 1 then case head list of
                    (key, value) -> case value of
                        String str -> resolve (Vector.tail lets) $
                            HashMap.insert key (unpack str) resolvedLets

                        _ -> Left $ unpack key ++ Data.constTypeError

                else Left Data.letsStructureError

            _ -> Left Data.letsStructureError

        | otherwise = Right resolvedLets

replaceLets :: [Text] -> String -> HashMap Text String -> String
replaceLets letNames formula lets = foldr
    (\letName out ->
        let maybeFormulaValue = HashMap.lookup (pack letName) lets
        in case maybeFormulaValue of
            Just parsedFormula -> replace ("@" ++ letName ++ "\\?") out parsedFormula
            Nothing            -> "ERROR"
    ) formula $ map unpack letNames

runCommands :: Bool -> [String] -> IO ()
runCommands isAsync = (if isAsync then mapConcurrently_ else mapM_) exitIfCmdIsNotValid

-- decode and parsing .yaml file
yamlParse :: ByteString -> [String] -> Bool -> IO ()
yamlParse equations formulas isAsync = case equationsContent of 
    Right (Object equationsHash) ->
        let maybeLets           = HashMap.lookup (pack "let") equationsHash
            maybeSolvedFormulas = solveAll equationsHash formulas
        in case maybeSolvedFormulas of
            Right solvedFormulas -> case maybeLets of
                Just lets -> case lets of
                    Array letsArray -> case resolveLets letsArray of
                        Right resolvedLets ->
                            let letNames = HashMap.keys resolvedLets
                            -- in runCommands
                            --     isAsync $ map (\formula -> replaceLets letNames formula resolvedLets) solvedFormulas
                            in runCommands
                                isAsync $
                                map (\formula -> replaceLets letNames formula resolvedLets) solvedFormulas

                        Left errorText -> die errorText

                    _ -> die Data.letsStructureError

                Nothing   -> runCommands isAsync solvedFormulas

            Left unknownFormulaName -> die $ Data.formulaNameError ++ unknownFormulaName

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