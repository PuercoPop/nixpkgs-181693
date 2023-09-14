# Nix: How to handle Gemfile other files when using bundlerEnv

If your Gemfile references other files, such as .ruby-verison, .tools-version or
vendored gems, bundlerEnv will run into issues as it copies the Gemfile and
Gemfile.lock to a separate directory in the store. When evaluating the Gemfile
you'll run into errors as the other files are not present. To fix we need to use
the `extraConfigPaths` option for bundlerEnv. In `shell.nix` you'll find a small
setup to show you how its done.

```shell
nix-shell -A default
rackup # the pudding
```


Additionally, bundler started supporting a keyword argument to the ruby method
named file: in version 2.4.19. So if your Gemfile has `ruby file: .ruby-verison`
you'll need to ensure that the bundler is 2.4.19 or higher. This might involve
updating the bundler version used by bundlerEnv. I've also included it in the
example.
