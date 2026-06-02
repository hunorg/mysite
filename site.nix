{ pkgs }:
let
  inherit (pkgs) lib htnl;
  inherit (htnl) document raw;
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
    figcaption
    pre
    code
    span
    nav
    ul
    li
    address
    footer
    a
    ;

  about = "I am a software developer with a focus on functional programming, particularly in Elm, Haskell, and Nix/NixOS.";

  cow =
    pkgs.runCommand "cow.txt" { nativeBuildInputs = [ pkgs.cowsay ]; }
      ''cowsay -W 40 ${lib.escapeShellArg about} > $out'';

  css = ''
    *, *::before, *::after { box-sizing: border-box; }
    html {
      -webkit-text-size-adjust: 100%;
      color-scheme: light;
    }
    html, body { margin: 0; padding: 0; background: #fff; color: #000; }
    body {
      font-family: ui-serif, Georgia, "Times New Roman", serif;
      font-size: 1.0625rem;
      line-height: 1.6;
      max-width: 36rem;
      margin: clamp(2rem, 6vw, 4rem) auto;
      padding: 0 clamp(1rem, 4vw, 1.25rem) clamp(2rem, 6vw, 4rem);
      padding-bottom: max(clamp(2rem, 6vw, 4rem), env(safe-area-inset-bottom));
    }
    h1 {
      font-size: 1.5rem;
      font-weight: 600;
      margin: 0 0 clamp(2rem, 5vw, 3rem);
      letter-spacing: -0.01em;
    }
    h2 {
      font-size: 0.9rem;
      font-weight: 600;
      margin: clamp(1.75rem, 5vw, 2.5rem) 0 0.75rem;
      text-transform: lowercase;
      letter-spacing: 0.06em;
      color: #444;
    }
    p { margin: 0 0 0.75rem; }
    a {
      color: inherit;
      text-decoration: underline;
      text-underline-offset: 0.18em;
      text-decoration-thickness: 1px;
    }
    @media (hover: hover) { a:hover { text-decoration-thickness: 2px; } }
    ul { list-style: none; margin: 0; padding: 0; }
    li { margin: 0 0 0.5rem; }
    code {
      font-family: ui-monospace, "SFMono-Regular", Menlo, Consolas, monospace;
      font-size: 0.92em;
    }
    .project-title { font-weight: 600; }
    .project-note { font-style: italic; color: #666; }
    section { margin: 0 0 clamp(1.5rem, 4vw, 2rem); }
    .cow {
      position: relative;
      margin: clamp(2.5rem, 7vw, 4rem) 0;
      text-align: center;
    }
    .cow pre {
      display: inline-block;
      text-align: left;
      font-family: ui-monospace, "SFMono-Regular", Menlo, Consolas, monospace;
      font-size: clamp(0.625rem, 2.6vw, 0.8125rem);
      line-height: 1.2;
      margin: 0;
      white-space: pre;
    }
    .cow figcaption {
      margin-top: 0.75rem;
      font-size: 0.78rem;
      color: #888;
      font-style: italic;
      letter-spacing: 0.04em;
    }
    .cow::after {
      content: "moo";
      position: absolute;
      top: -1.2rem;
      right: clamp(0.5rem, 8%, 2rem);
      font-family: ui-monospace, "SFMono-Regular", Menlo, Consolas, monospace;
      font-size: 0.875rem;
      color: #555;
      opacity: 0;
      pointer-events: none;
      animation: moo 7s ease-in-out infinite;
    }
    @media (prefers-reduced-motion: reduce) {
      .cow::after { animation: none; opacity: 0.55; transform: none; }
    }
    @keyframes moo {
      0%, 60%, 100% { opacity: 0; transform: translateY(0); }
      70%           { opacity: 0.9; transform: translateY(-0.15rem); }
      85%           { opacity: 0.5; transform: translateY(-0.6rem); }
      96%           { opacity: 0;   transform: translateY(-1rem); }
    }
    address { font-style: normal; }
    footer {
      margin-top: clamp(2.5rem, 6vw, 4rem);
      padding-top: 1.5rem;
      border-top: 1px solid #eee;
      font-size: 0.85rem;
      color: #666;
    }
  '';

  page = html { lang = "en"; } [
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

      (section [
        (h2 "Projects")
        (ul [
          (li [
            (a { href = "https://pointy.cloud/"; } (
              span { class = "project-title"; } "Pointy Notebook"
            ))
            (span { class = "project-note"; } " — collaborator since the start.")
            " Keeps research computation tidy: reusable analyses as project pages with forms, live runs, browsable outputs, and commit-pinned share links."
          ])
          (li [
            (a { href = "https://terminal-top.eket.org/"; } (
              span { class = "project-title"; } "terminal-top"
            ))
            " — A Nix-driven terminal dashboard for live, structured data. Define a source URL and a panel layout in a "
            (code ".nix")
            " file and it renders in the terminal — no app, no account, no cloud."
          ])
        ])
      ])

      (figure { class = "cow"; } [
        (pre (lib.readFile cow))
        (figcaption "cowsay")
      ])

      (section [
        (h2 "Links")
        (nav (ul [
          (li (a { href = "https://www.linkedin.com/in/hunorgered/"; } "LinkedIn"))
          (li (a { href = "https://github.com/hunorg"; } "GitHub"))
          (li (a { href = "https://gitlab.com/hunorg"; } "GitLab"))
        ]))
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
        ", a Nix library for making websites."
      ])
    ])
  ];
in
pkgs.htnl.bundle {
  name = "hunor-site";
  htmlDocuments."index.html" = document page;
}
