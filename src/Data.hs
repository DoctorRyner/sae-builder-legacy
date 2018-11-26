-- module for containing pure information
module Data where

appName :: String
appName = "sae"

-- default file name which contain formulas
fileToSolve :: String
fileToSolve = "Equations.yaml"

-- error if use provided more than 1 argument
argsError :: String
argsError = "Please, specify just one equation"

-- error if can't find @fileToSolve
fileToSolveError :: String
fileToSolveError = "There is no " ++ fileToSolve

-- error if formula cannot be found
formulaNameError :: String
formulaNameError = "There is no such a formula as "

-- specifies name for default task formula label
defaultEquation :: String
defaultEquation = "default"

-- yaml file pares error (should be HashMap)
yamlParseError :: String
yamlParseError = "Error! While parcing yaml file I didn't get HashMap"

yamlIncorrectStructureError :: String
yamlIncorrectStructureError = "Error! YAML file isn't correct and may have errors"

-- help msg
help :: String
help = "https://github.com/DoctorRyner/sae"

-- async key error
asyncKeyError :: String
asyncKeyError = "Try to execute " ++ appName ++ " help"