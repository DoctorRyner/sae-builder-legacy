{-# LANGUAGE LambdaCase #-}
module Main where

import qualified Config
import qualified Error
import qualified Data.Vector as Vector
import qualified Data.HashMap.Strict as HashMap
import Data.HashMap.Strict (HashMap)
import Data.Text (Text, pack, unpack)
import Data.Yaml (Object, Value(..), decodeEither')
import Data.Yaml.Aeson (Array)
import Data.Maybe (fromJust)
import System.Environment (getArgs)
import Data.ByteString.Char8 (ByteString)
import Control.Concurrent.Async (mapConcurrently_)
import Impure (maybeFileBS, exitIfCmdIsNotValid)
import Regex.Parser (replace)
import System.Exit (die)

-- if all provided equation names are valid then return list of equations content
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
                _                           -> Left $ unpack headFormula ++ Error.wrongFormulaType
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

                        _ -> Left $ unpack key ++ Error.constType

                else Left Error.letsStructure

            _ -> Left Error.letsStructure

        | otherwise = Right resolvedLets

replaceLets :: [Text] -> String -> HashMap Text String -> String
replaceLets letNames formula lets =
    -- let possibleLets = getAll "@([^?]*)?" formula
    -- in
    foldr
        (\letName out -> replace ("$" ++ letName ++ "\\?") out (fromJust $ HashMap.lookup (pack letName) lets)
        ) formula $ map unpack letNames

runCommands :: Bool -> [String] -> IO ()
runCommands isAsync = (if isAsync then mapConcurrently_ else mapM_) exitIfCmdIsNotValid

-- decode and parsing .yaml file
yamlParse :: ByteString -> [String] -> Bool -> IO ()
yamlParse equations formulas isAsync = case decodeEither' equations of 
    Right (Object equationsHash) ->
        let maybeLets = HashMap.lookup (pack "let") equationsHash
        in case solveAll equationsHash formulas of
            Right solvedFormulas -> case maybeLets of
                Just lets -> case lets of
                    Array letsArray -> case resolveLets letsArray of
                        Right resolvedLets ->
                            let letNames = HashMap.keys resolvedLets
                            in runCommands
                                isAsync $ map (\formula -> replaceLets letNames formula resolvedLets) solvedFormulas

                        Left errorText -> die errorText

                    _ -> die Error.letsStructure

                Nothing   -> runCommands isAsync solvedFormulas

            Left unknownFormulaName -> die $ Error.formulaName ++ unknownFormulaName

    -- in case return Right (_) in place of Right _
    Right _ -> die Error.yamlParse

    Left  _ -> die Error.yamlIncorrectStructure

run :: ByteString -> [String] -> IO ()
run equations args = case length args of
    0 -> yamlParse equations [ Config.defaultEquation ] False

    1 -> case firstArg of
        "--async" -> die Error.asyncKey
        "--help"  -> putStrLn Config.help
        "--elmInit" -> do
            writeFile "Utils.elm" =<< readFile "resources/Utils.elm"
            writeFile "Main.elm"  =<< readFile "resources/Main.elm"
        _         -> yamlParse equations [ firstArg ] False

    _ -> case firstArg of
        "--async" -> yamlParse equations (tail args) True
        _         -> yamlParse equations args False

  where firstArg = head args

main :: IO ()
main = maybeFileBS Config.fileToSolve >>= \case Just file -> run file =<< getArgs
                                                Nothing   -> die Error.fileToSolve