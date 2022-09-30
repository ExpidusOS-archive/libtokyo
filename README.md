# libtokyo

The `libadwaita`-like library for ExpidusOS, includes GTK themes for both 3.0 and 4.0. `libtokyo` also includes colors for Tailwindcss for websites.

## Dependencies

### Host

* `node` (**version** >= 16, **only if using `gtk4` option**)
* `meson`
* `gettext`
* `pkg-config`
* `sass` (**required if not using nodejs**)
* `vala`

### Target

* `libadwaita-1` (**only if using `gtk4` option**)
* `libhandy-1` (**only if using `gtk3` option**)

## Building

`libtokyo` uses Meson for building but it can be built and packaged with the Nix package manager.
`libtokyo` uses Git submodules and so it is essential to pull those before building.

### Meson

```
$ meson . builddir
$ ninja -C builddir
$ sudo ninja -C builddir install
```

This will build `libtokyo` into `./builddir` and install it to `/usr/local`. It it recommended to configure the install prefix to `/usr` if your packaging it.

### Nix

`libtokyo` includes a Nix Flake which makes development, building, and packaging easy.
However, Flakes are a relatively new feature and as we utilize Git submodules, it is required to pass `?submodules=1`.
Please read the [Nix Wiki page on Flakes](https://nixos.wiki/wiki/Flakes) before using the `libtokyo` Nix Flake.

#### Building

Run `nix build '.?submodules=1'` and Nix will automatically build `libtokyo` and output the built library into `./result`.

#### Development Shell

Nix includes a development shell and you can enter the one for `libtokyo` with `nix develop '.?submodules=1'`.
It will build or install all required dependencies that are not present. You can then build `libtokyo` like normal
and use it from there. However, you should not install `libtokyo` this way as it will cause unintended side effects.
If you wish to install `libtokyo`, then do not use `nix develop` to build it.
