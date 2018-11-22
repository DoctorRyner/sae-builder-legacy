# sae (Solver of All Equations)

This is easy building tool. It aims to be like `make` but more powerful (in future) and with additional haskell sugar

# How to use?

Just create Equations.yaml file and define your formulas (scripts) like that:

```yaml
build: stack build --fast

run: my-awesome-app-exe # yes, it uses stack exec by default, maybe I should remove that feature?
```

And then use command `solve formula_name`, where solve is command and formula_name is formula (Maybe I shoud rename command from solve to sae?) <br />

In some cases you might want define default formula like this:

```yaml
# build and run
default:
    solve build && solve run

build: stack build --fast

run: my-awesome-app-exe # yes, it uses stack exec by default
```