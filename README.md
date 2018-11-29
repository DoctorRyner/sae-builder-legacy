# sae (Solver of All Equations)

This is easy building tool. It aims to be like `make` but more powerful (in future) and with additional Haskell sugar

# How to use?

Just create `Equations.yaml` file and define your formulas (scripts) like that:

```yaml
build: stack build --fast

run: stack exec my-awesome-app-exe
```

And then use command `sae formula_name`, where `sae` is command and `formula_name` is formula (Maybe I shoud rename command from sae to sae?). How to build and install? Just clone this repo, enter it and type `stack build` then copy `sae` executable placing of which you can determine from stack build prompt, to something like `/usr/local/bin` if you use `Unix-like OS` to have access to this tool from everywhere

In some cases you might want to define default formula like this:

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
- devBuildOptions: --fast

default: sae devBuild

devBuild: stack build @devBuildOptions?

run: stack exec @appExecutableName?
```

# TODO
- [x] multiple arguments
- [x] async formulas execution
- [x] constants support
- [ ] constants validation checking
- [ ] custom haskell code insertion with defined constants support
- [ ] --check option which checks .yaml's file correctness
- [ ] config options like to check yaml file before running or not to check
- [ ] manage system dependencies (unlikely)