# To reproduce

```shell
nix-shell
rackup
```

# To test the fix

```shell
nix-shell --arg nixpkgs $HOME/src/nixpkgs
rackup
```
