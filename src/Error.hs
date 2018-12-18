module Error where

import qualified Config

-- error if can't find @fileToSolve
fileToSolve :: String
fileToSolve = "There is no " ++ Config.fileToSolve

-- error if formula cannot be found
formulaName :: String
formulaName = "There is no such a formula as "

-- yaml file pares error (should be HashMap)
yamlParse :: String
yamlParse = "Error! While parcing yaml file I didn't get HashMap"

yamlIncorrectStructure :: String
yamlIncorrectStructure = "Error! YAML file isn't correct and may have errors"

-- async key error
asyncKey :: String
asyncKey = "Try to execute " ++ Config.appName ++ " help"

wrongFormulaType :: String
wrongFormulaType = " has wrong type, must be String"

letsStructure :: String
letsStructure = "let structure is incorrect, consts mush be String HashMap"

constType :: String
constType = " const must be String"