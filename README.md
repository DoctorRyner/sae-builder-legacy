# sae (Solver of All Equations)

This is easy building tool. It aims to be like `make` for see but more powerful (in future) and with additional haskell sugar

# How to use?

Just create Equations.yaml file and define your formulas (scripts) like that:

```yaml
build: stack build --fast

run: my-awesome-app-exe # yes, it uses stack exec by default, maybe I should remove that feature?
```

In some cases you might want define default formula like this:

```yaml
buildAndRun:
    solve build && solve run

build: stack build --fast

run: my-awesome-app-exe # yes, it uses stack exec by default
```