{ system ? builtins.currentSystem
, nixpkgs ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  }
, pkgs ? import nixpkgs {
    overlays = [ ];
    config = { };
    inherit system;
  }
}:
let
  ruby = pkgs.ruby_3_2.override {
    bundler = pkgs.bundler;
  };
  bundler = pkgs.buildRubyGem {
    inherit ruby;
    name = "$bundler-2.4.19";
    gemName = "bundler";
    version = "2.4.19";
    source.sha256 = "sha256-M03HlkODhHMv3xm/ovYjdTt+2FFg0Izh8gAJmEzvs2I=";
    dontPatchShebangs = true;

    postFixup = ''
      sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
    '';
  };

  gems = pkgs.bundlerEnv.override { inherit bundler; } {
    name = "gems";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    extraConfigPaths = [ "${./.}/.ruby-version" ];
  };
in
{
  default = pkgs.mkShell {
    buildInputs = [
      gems
      gems.wrappedRuby
    ];
  };
  bundler = pkgs.mkShell {
    buildInputs = [
      pkgs.bundix
      bundler
    ];
  };
  update = pkgs.mkShell {
    buildInputs = [
      pkgs.bundix
    ];
  };
  pkgs = pkgs;
}
