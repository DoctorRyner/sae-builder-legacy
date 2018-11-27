-- module for impure utility functions
module Impure where

import Control.Exception (try, SomeException)
import qualified Data.ByteString.Char8 as BS
import Data.ByteString.Char8 (ByteString)


-- maybeReadFile :: FilePath -> IO (Maybe String)
-- maybeReadFile path = (try $ readFile path :: IO (Either SomeException String)) >>= \res -> return $ rightToMaybe res

maybeReadFileBS :: FilePath -> IO (Maybe ByteString)
maybeReadFileBS path = (try $ BS.readFile path :: IO (Either SomeException ByteString))
    >>= \res -> return $ either (const Nothing) Just res