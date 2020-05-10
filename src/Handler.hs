module Handler where

import Prelude hiding (putStrLn)
import CLI.Colored (putStrLn)

import Control.Monad
import Data.Maybe

import Config
import Lens
import Types

withColor :: String -> String -> String
withColor color str = concat ["#", color, "(" ++ str ++ ")"]

handler :: Options -> IO ()
handler opts = do
    when (opts ^. #showVersion) $ putStrLn $ config ^. #version

    mapM_
        (\op -> putStrLn $ withColor "red" $ op ++ " isn't implemented yet"
        )
        $ catMaybes
            [ if opts ^. #async then Just "async" else Nothing
            , if opts ^. #toMakefile then Just "toMakefile" else Nothing
            , if opts ^. #fromMakefile then Just "fromMakefile" else Nothing
            ]