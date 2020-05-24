module Handler where

import Prelude hiding (putStrLn)
import CLI.Colored (putStrLn)

import Control.Monad
import Data.Maybe
import qualified Data.Text          as T
import System.Process

import Config
import Lens
import Types
import Data.Yaml
import qualified Data.HashMap.Strict as H

-- withColor :: String -> String -> T.Text
-- withColor color str = T.concat ["#", color, "(" ++ str ++ ")"]

handler :: Options -> Value -> [T.Text] -> IO ()
handler opts file formulas = do
    when (opts ^. #showVersion) $ putStrLn $ config ^. #version

    mapM_
        (\op -> putStrLn $ op ++ " isn't implemented yet"
        )
        $ catMaybes
            [ if opts ^. #async then Just "async" else Nothing
            , if opts ^. #toMakefile then Just "toMakefile" else Nothing
            , if opts ^. #fromMakefile then Just "fromMakefile" else Nothing
            ]

    let res = yamlProcessor file

    printHmap res

    case res of
        Right r ->
            mapM_
                (\formula -> do
                    let fres = H.lookup formula r
                    case fres of
                        Just form -> callCommand $ T.unpack form
                        Nothing   -> print $ "No such formula: " <> formula
                ) formulas

        Left  e -> print e

printHmap :: Either T.Text (H.HashMap T.Text T.Text) -> IO ()
printHmap hmap =
    case hmap of
        Right r -> mapM_
            (\(k, v) ->
                putStrLn $ "key: " ++ show k
                      ++ "| val: " ++ show v
            ) (H.toList r)
        Left  e -> print e

yamlProcessor :: Value -> Either T.Text (H.HashMap T.Text T.Text)
yamlProcessor = \case
    Object val -> checkArray val
    _          -> Left "Wrong file content, Object/HashMap expected"

  where
    checkArray :: Object -> Either T.Text (H.HashMap T.Text T.Text)
    checkArray obj =

        if length val == length cval && length val > 0
            then Right cval
            else Left "Err"

      where
        val  = obj
        cval =
            H.mapMaybe
                (\v -> case v of
                    String x -> Just (x)
                    _        -> Nothing
                ) val