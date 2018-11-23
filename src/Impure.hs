module Impure where

import Control.Exception (try, SomeException)
import Data.Either.Combinators (rightToMaybe)
import System.Process (callCommand)
import qualified Data.ByteString.Char8 as BS
import Data.ByteString.Char8 (ByteString)
import qualified Data

-- maybeReadFile :: FilePath -> IO (Maybe String)
-- maybeReadFile path = (try $ readFile path :: IO (Either SomeException String)) >>= \res -> return $ rightToMaybe res

maybeReadFileBS :: FilePath -> IO (Maybe ByteString)
maybeReadFileBS path =
    (try $ BS.readFile path :: IO (Either SomeException ByteString)) >>= \res -> return $ rightToMaybe res

cmdify :: String -> IO ()
cmdify = callCommand