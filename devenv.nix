{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.python312Packages.openapi-spec-validator
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    openapi-spec-validator spec/*.yaml
  '';

  scripts.format.exec = ''
    yamlfmt .
    markdownlint --fix .
    pre-commit run --all-files
  '';

  # https://devenv.sh/pre-commit-hooks/
  git-hooks.hooks = {
    typos.enable = true;
    yamllint.enable = true;
    yamlfmt.enable = true;
    commitizen.enable = true;
    nixfmt-rfc-style.enable = true;
    markdownlint.enable = true;
  };

  git-hooks.hooks.validate-spec = {
    enable = true;

    # The name of the hook (appears on the report table):
    name = "Validate OpenAPI spec";

    # The command to execute (mandatory):
    entry = "openapi-spec-validator";

    # The pattern of files to run on (default: "" (all))
    # see also https://pre-commit.com/#hooks-files
    files = "^spec/.*\\.(yaml|yml|json)$";

    # The language of the hook - tells pre-commit
    # how to install the hook (default: "system")
    # see also https://pre-commit.com/#supported-languages
    language = "system";

    # Set this to false to not pass the changed files
    # to the command (default: true):
    pass_filenames = true;
  };
}
