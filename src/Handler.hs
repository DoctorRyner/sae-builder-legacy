module Handler where

import Prelude hiding (putStrLn)
import CLI.Colored (putStrLn)

import Control.Monad
import Data.Maybe

import Config
import Lens
import Types
import Data.Yaml
import qualified Data.HashMap.Strict as H

withColor :: String -> String -> String
withColor color str = concat ["#", color, "(" ++ str ++ ")"]

handler :: Options -> Value -> IO ()
handler opts val = do
    when (opts ^. #showVersion) $ putStrLn $ config ^. #version

    mapM_
        (\op -> putStrLn $ withColor "red" $ op ++ " isn't implemented yet"
        )
        $ catMaybes
            [ if opts ^. #async then Just "async" else Nothing
            , if opts ^. #toMakefile then Just "toMakefile" else Nothing
            , if opts ^. #fromMakefile then Just "fromMakefile" else Nothing
            ]

    let res = yamlProcessor val

    print res

    mempty

yamlProcessor :: Value -> Either String [String]
yamlProcessor = \case
    Object val -> checkArray val
    _          -> Left "Naegoril na value)00)"

  where
    checkArray :: Object -> Either String [String]
    checkArray vObj =
        map (x -> x) obj
            -- [String xs] -> Right ["No, fuck you"]
            -- _          -> Left  "Fuck you"

      where
        obj = H.elems vObj