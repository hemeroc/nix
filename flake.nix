{
  description = "My personal flakes that I need to work";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        outlook_src = pkgs.fetchurl {
          url = "https://go.microsoft.com/fwlink/p/?linkid=525137";
          sha256 = "sha256-ZCUNkymcCDSQz0R5zL22ndILoUzOLM/JyaqYAsxfcDs=";
          curlOptsList = [ "-L" ];
        };
        teams_src = pkgs.fetchurl {
          url = "https://statics.teams.cdn.office.net/production-osx/enterprise/webview2/lkg/MicrosoftTeams.pkg";
          sha256 = "sha256-NUCQo3BbHizAOuY41JASAsMZOwSEIIAjji6HRkjs4Xs=";
        };
        googlechrome_src = pkgs.fetchurl {
          url = "https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg";
          sha256 = "sha256-NUCQo3BbHizAOuY41JASAsMZOwSEIIAjji6HRkjs4Xs=";
        };
      in
      {
        packages = rec {
          outlook = pkgs.stdenv.mkDerivation {
            name = "outlook.app";
            src = outlook_src;
            phases = [ "unpackPhase" "installPhase" ];
            unpackPhase = ''
              ${pkgs.xar}/bin/xar -xf $src
              cat Microsoft_Outlook.pkg/Payload | gunzip -dc | ${pkgs.cpio}/bin/cpio -i
            '';
            installPhase = ''
              mkdir -p $out/Applications
              cp -r Microsoft\ Outlook.app $out/Applications/Microsoft\ Outlook.app
            '';
          };
          outlookWrapper = pkgs.writeShellScriptBin "outlookWrapper" ''
            open ${outlook}/Applications/Microsoft\ Outlook.app
          '';
        };
      }
    );
}
# 7z x KeePassXC-2.7.6-arm64.dmg KeePassXC/KeePassXC.app -o./
