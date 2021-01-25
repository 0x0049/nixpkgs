{ stdenv, fetchFromGitHub, ocamlPackages, CoreServices }:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.142.0";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "flow";
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-peK9+3RsY+4LuN+N/w+HIFX18yDZfqEuioBezNq7yXw=";
  };

  installPhase = ''
    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow
  '';

  buildInputs = (with ocamlPackages; [ ocaml findlib ocamlbuild dtoa core_kernel sedlex_2 ocaml_lwt lwt_log lwt_ppx ppx_deriving ppx_gen_rec ppx_tools_versioned visitors wtf8 ocaml-migrate-parsetree ])
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = "https://flow.org/";
    changelog = "https://github.com/facebook/flow/releases/tag/v${version}";
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    broken = stdenv.isAarch64; # https://github.com/facebook/flow/issues/7556
    maintainers = with maintainers; [ marsam puffnfresh ];
  };
}
