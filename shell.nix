{ system ? builtins.currentSystem,
  nixpkgs ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  },
  pkgs ? import nixpkgs {
    overlays = [];
    config = {};
    inherit system;
  }
}:
let
  ruby = pkgs.ruby_3_2;
  gems = pkgs.bundlerEnv {
    name = "gems";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    gemfileExtraFiles = [ ./.ruby-version ];
    extraConfigPaths = [ "${./.}/.ruby-version" ];
  };
in
pkgs.mkShell {
  buildInputs = [
    gems
    gems.wrappedRuby
  ];
}
