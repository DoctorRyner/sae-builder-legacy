module Impure where

import Control.Exception (try, SomeException)
import Data.Either.Combinators (rightToMaybe)
import System.Process (callCommand)
import qualified Data

maybeReadFile :: String -> IO (Maybe String)
maybeReadFile path = (try $ readFile path :: IO (Either SomeException String)) >>= \res -> return $ rightToMaybe res

cmdify :: String -> IO ()
cmdify cmd = callCommand $ Data.cmdPrefix ++ cmd