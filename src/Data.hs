module Data where

fileToSolve :: String
fileToSolve = "Equations.yaml"

argsError :: String
argsError = "Please, specify just one equation"

fileToSolveError :: String
fileToSolveError = "There is no " ++ fileToSolve

defaultEquation :: String
defaultEquation = "default"