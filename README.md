# sae (Solver of All Equations)

This is easy building tool. It aims to be like `make` but more powerful (in future) and with additional Haskell sugar

# How to build?

Just clone this repo `git clone https://github.com/DoctorRyner/sae`, enter it `cd sae`, run `stack setup && stack build` (you must have stack installed, if it is not than follow that https://docs.haskellstack.org/en/stable/README/), next place compiled executable (executable named `sae` and you can determine where it placed from `stack build` command, just look up for something like `Installing executable...`) somewhere like `/usr/local/bin` (if you use Unit-like OS). Thats it, just type `sae --help` or read `How to use?` section

# How to use?

Just create `Equations.yaml` file and define your formulas (scripts) like that:

```yaml
build: stack build --fast

run: stack exec my-awesome-app-exe
```

And then use command `sae formula_name`, where `sae` is command and `formula_name` is formula. In some cases you might want to define default formula like this:

```yaml
# build and run
default: sae build run

build: stack build --fast

run: stack exec my-awesome-app-exe
```

So, as you can see, you can run multiple tasks one after another like:

```yaml
default: sae build run
```
Or even asynchronously:

```yaml
default: sae --async build run # but I don't recommend to run app before building completion :)
```

You can use predefined constants like these:

```yaml
let:
- appExecutableName: sae
- devBuildOptions: --fast --no-test

default: sae devBuild run

devBuild: stack build @devBuildOptions?

run: stack exec @appExecutableName?
```

let must be list of key-string values like `constName: testValue`, otherwise it will show you error

# TODO
- [x] multiple arguments
- [x] async formulas execution
- [x] constants support
- [x] constants validation checking
- [ ] custom haskell code insertion with defined constants support
- [ ] config options like `let` field but for options
- [ ] manage system dependencies (unlikely)