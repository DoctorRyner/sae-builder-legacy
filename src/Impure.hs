-- module for impure utility functions
module Impure where

import qualified Data.ByteString.Char8 as BS
import Control.Exception (try, SomeException)
import Data.ByteString.Char8 (ByteString)
import System.Process (callCommand)
import System.Exit (exitFailure)

maybeReadFileBS :: FilePath -> IO (Maybe ByteString)
maybeReadFileBS path = (try $ BS.readFile path :: IO (Either SomeException ByteString))
    >>= \res -> return $ either (const Nothing) Just res

exitIfCmdIsNotValid :: String -> IO ()
exitIfCmdIsNotValid text = (try $ callCommand text :: IO (Either SomeException ()))
    >>= \res ->
        case res of
            Right cmd -> return cmd
            Left  _   -> exitFailure

test :: String -> IO ()
test = callCommand