module Regex.Parser (replace, getAll) where

import Text.Regex (mkRegex, subRegex)
import Text.Regex.TDFA ((=~))

getAll :: String -> String -> [String]
getAll expr basis = map (!!1) $ basis =~ expr :: [String]

replace :: String -> String -> String -> String
replace experssion textToParse = subRegex (mkRegex experssion) textToParse