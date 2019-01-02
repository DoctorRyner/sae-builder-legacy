module Error where

import qualified Config

-- error if can't find @fileToSolve
fileToRun :: String
fileToRun = "There is no " ++ Config.fileToRun

-- error if formula cannot be found
scriptName :: String
scriptName = "There is no such a formula as "

-- yaml file pares error (should be HashMap)
yamlParse :: String
yamlParse = "Error! While parcing yaml file I didn't get HashMap"

yamlIncorrectStructure :: String
yamlIncorrectStructure = "Error! YAML file isn't correct and may have errors"

-- async key error
asyncKey :: String
asyncKey = "Try to execute " ++ Config.appName ++ " help"

scriptType :: String
scriptType = " has wrong type, must be String"

letsStructure :: String
letsStructure = "let structure is incorrect, consts mush be String HashMap"

constType :: String
constType = " const must be String"