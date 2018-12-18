-- module for containing pure information
module Config where

appName :: String
appName = "sae"

-- default file name which contain formulas
fileToSolve :: String
fileToSolve = "Equations.yaml"

-- specifies name for default task formula label
defaultEquation :: String
defaultEquation = "default"

-- help msg
help :: String
help = "https://github.com/DoctorRyner/sae"