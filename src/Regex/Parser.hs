module Regex.Parser (replace) where

import Text.Regex (mkRegex, subRegex)
-- import Text.Regex.PCRE ((=~))

replace :: String -> String -> String -> String
replace experssion textToParse = subRegex (mkRegex experssion) textToParse