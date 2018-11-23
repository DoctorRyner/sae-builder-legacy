-- module for containing pure information
module Data where

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
formulaNameError = "There is no such a formula as"

-- specifies name for default task formula label
defaultEquation :: String
defaultEquation = "default"