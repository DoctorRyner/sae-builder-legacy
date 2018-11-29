-- module for impure utility functions
module Impure where

import qualified Data.ByteString.Char8 as BS
import Control.Exception (try, SomeException)
import Data.ByteString.Char8 (ByteString)
import System.Process (callCommand)

maybeReadFileBS :: FilePath -> IO (Maybe ByteString)
maybeReadFileBS path = (try $ BS.readFile path :: IO (Either SomeException ByteString))
    >>= \res -> return $ either (const Nothing) Just res

maybeCmd :: String -> IO (Maybe ())
maybeCmd text = (try $ callCommand text :: IO (Either SomeException ()))
    >>= \res -> return $ either (const Nothing) Just res