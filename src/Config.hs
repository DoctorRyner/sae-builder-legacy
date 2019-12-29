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
help = concat
    [ "Checkout first https://github.com/DoctorRyner/sae#how-to-use\n\n"

    , "In short, you need to create Equations.yaml, sae works similar to Makefile\n"
    , "You need to specify formulas to run like 'sae app-build app-test'\n\n"

    , "To create a new formula, you need to define it in Equations.yaml like this:\n\n"

    , "    build: echo 'Building ... DONE!'\n\n"

    , "Also, you can define the default formula like this:\n\n"

    , "    default: sae build\n\n"

    , "This formula would be run if you don't specify any formula\n\n"

    , "You can run formulas asynchronously by using --async flag\n\n"

    , "You can define constants and use them like this:\n\n"

    , "    let:\n"
    , "    - appName: My Awesome App\n"
    , "    - appVersion: 0.4\n\n"

    , "    greetings: Hi, I'm the creator of <appName> and it's my new <appVersion> version!\n"
    ]
