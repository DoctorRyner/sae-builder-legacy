{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Regex where

import Data.Coerce (coerce)
import Text.Regex.PCRE ((=~~))

newtype FailToLeft a = FailToLeft (Either String a)
    deriving (Applicative, Functor, Show)

instance Monad FailToLeft where
    FailToLeft x >>= f = FailToLeft (x >>= coerce f)
    fail err = FailToLeft (Left err)

getAll :: String -> String -> Maybe [String]
getAll text expr = case text =~~ expr :: FailToLeft [[String]] of
    FailToLeft (Left err ) -> if err /= "regex failed to match" then Nothing else Just []
    FailToLeft (Right res) -> Just $ map last res