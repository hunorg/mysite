{
  lib,
  htnl,
  cowsay,
  runCommand,
  validator-nu,
}:
let
  inherit (htnl) bundle document raw;
  inherit (htnl.polymorphic.partials)
    html
    head
    body
    meta
    title
    style
    h1
    h2
    section
    figure
    pre
    code
    span
    ul
    li
    address
    footer
    a
    ;

  about = "I am a software developer with a focus on functional programming, particularly in Elm, Haskell, and Nix/NixOS.";

  css = ''
    *, *::before, *::after { box-sizing: border-box; }
    html {
      -webkit-text-size-adjust: 100%;
      color-scheme: dark;
      background: #000a0a;
      color: #ffffff;
    }
    body {
      min-height: 100vh;
      font-family: ui-monospace, "SFMono-Regular", Menlo, Consolas, monospace;
      line-height: 1.65;
      max-width: 42rem;
      margin: clamp(2rem, 6vw, 4rem) auto;
      padding: 0 clamp(1rem, 4vw, 1.25rem) clamp(2rem, 6vw, 4rem);
    }
    h1 {
      font-size: clamp(1.35rem, 4vw, 1.6rem);
      font-weight: 600;
      margin: 0 0 clamp(2rem, 5vw, 3rem);
      letter-spacing: -0.02em;
    }
    h1::before { content: "> "; font-weight: 400; }
    h2 {
      font-size: 0.9rem;
      font-weight: 600;
      margin: clamp(1.75rem, 5vw, 2.5rem) 0 0.75rem;
      text-transform: lowercase;
      letter-spacing: 0.06em;
    }
    h2::before { content: "# "; font-weight: 400; }
    a {
      color: #ffffff;
      text-decoration: underline;
      text-underline-offset: 0.2em;
      text-decoration-thickness: 1px;
    }
    ul { list-style: none; margin: 0; padding: 0; }
    li { margin: 0 0 0.6rem; }
    code { font-family: inherit; font-size: 0.95em; }
    @media (hover: hover) {
      a:hover { color: #000000; background: #ffffff; }
    }
    .project-title { font-weight: 700; }
    .project-note { font-style: italic; }
    section { margin: 0 0 clamp(1.75rem, 4vw, 2.25rem); }
    .cow { margin: clamp(2rem, 6vw, 3.5rem) 0; text-align: center; }
    .cow pre {
      display: inline-block;
      text-align: left;
      font-size: clamp(0.625rem, 2.55vw, 0.8125rem);
      line-height: 1.2;
      margin: 0;
    }
    address { font-style: normal; }
    footer {
      margin-top: clamp(2.5rem, 6vw, 4rem);
      padding-top: 1.5rem;
      border-top: 1px solid rgb(255 255 255 / 0.4);
      font-size: 0.85rem;
    }
  '';

  page = document (
    html { lang = "en"; } [
      (head [
        (meta { charset = "UTF-8"; })
        (meta {
          name = "viewport";
          content = "width=device-width, initial-scale=1";
        })
        (meta {
          name = "description";
          content = about;
        })
        (title "Hunor Geréd")
        (style (raw css))
      ])
      (body [
        (h1 "Hunor Geréd")

        (figure { class = "cow"; } (pre "@COW@"))

        (section [
          (h2 "Projects")
          (ul [
            (li [
              (a { href = "https://package.elm-lang.org/packages/421anon/elm-flow/latest/"; } (
                span { class = "project-title"; } "elm-flow"
              ))
              " — collaborative Elm package for writing effectful logic as composable steps: state, commands, async channels, and optics without a conventional "
              (code "update")
              " dispatcher. Built from concepts and code from elm-io and elm-procedure, with thanks to their authors."
            ])
            (li [
              (a { href = "https://pointy.cloud/"; } (span { class = "project-title"; } "Pointy Notebook"))
              (span { class = "project-note"; } " — collaborator since the start.")
              " Keeps research computation tidy: reusable analyses as project pages with forms, live runs, browsable outputs, and commit-pinned share links."
            ])
            (li [
              (a { href = "https://terminal-top.eket.org/"; } (span { class = "project-title"; } "terminal-top"))
              " — A Nix-driven terminal dashboard for live, structured data. Define a source URL and a panel layout in a "
              (code ".nix")
              " file and it renders in the terminal — no app, no account, no cloud."
            ])
          ])
        ])

        (section [
          (h2 "Links")
          (ul [
            (li (a { href = "https://www.linkedin.com/in/hunorgered/"; } "LinkedIn"))
            (li (a { href = "https://github.com/hunorg"; } "GitHub"))
            (li (a { href = "https://gitlab.com/hunorg"; } "GitLab"))
          ])
        ])

        (section [
          (h2 "Contact")
          (address (ul [
            (li [
              "Matrix — "
              (a { href = "https://matrix.to/#/@hunig:matrix.org"; } (code "@hunig:matrix.org"))
            ])
            (li [
              "Email — "
              (a { href = "mailto:hunorgered@gmail.com"; } "hunorgered@gmail.com")
            ])
          ]))
        ])

        (footer [
          "Built with "
          (a { href = "https://htnl.molybdenum.software/"; } "htnl")
          ", a Nix library for making websites. "
          (a { href = "https://github.com/hunorg/mysite"; } "Source")
          "."
        ])
      ])
    ]
  );

  bundled = bundle { htmlDocuments."index.html" = page; };
in
runCommand "hunor-site"
  {
    nativeBuildInputs = [
      cowsay
      validator-nu
    ];
  }
  ''
    mkdir -p "$out"
    cp -r ${bundled}/. "$out/"
    chmod -R u+w "$out"
    cow=$(cowsay -W 40 ${lib.escapeShellArg about} \
      | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
    substituteInPlace "$out/index.html" --replace-fail '@COW@' "$cow"
    vnu --Werror "$out/index.html"
  ''
