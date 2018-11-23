# sae (Solver of All Equations)

This is easy building tool. It aims to be like `make` but more powerful (in future) and with additional Haskell sugar

# How to use?

Just create `Equations.yaml` file and define your formulas (scripts) like that:

```yaml
build: stack build --fast

run: stack exec my-awesome-app-exe
```

And then use command `solve formula_name`, where `solve` is command and `formula_name` is formula (Maybe I shoud rename command from solve to sae?). How to build and install? Just clone this repo, enter it and type `stack build` then copy `solve` executable placing of which you can determine from stack build prompt, to something like `/usr/local/bin` if you use `Unix-like OS` to have access to this tool from everywhere

In some cases you might want to define default formula like this:

```yaml
# build and run
default: solve build && solve run

build: stack build --fast

run: my-awesome-app-exe # yes, it uses stack exec by default
```

# TODO
- [ ] default arguments straight execution
- [ ] multiple arguments
- [ ] async formulas execution
- [ ] constants support
- [ ] manage system dependencies (unlikely)