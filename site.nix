{
  lib,
  htnl,
  cowsay,
  runCommand,
  validator-nu,
}:
let
  inherit (htnl) bundle document;
  inherit (htnl.polymorphic.partials)
    a
    address
    body
    code
    figure
    footer
    h1
    h2
    head
    html
    img
    li
    link
    meta
    pre
    section
    span
    title
    ul
    ;

  about = "I am a software developer with a focus on functional programming, particularly in Elm, Haskell, and Nix/NixOS.";
in
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
    (link {
      rel = "stylesheet";
      href = ./style.css;
    })
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
        (li (
          a { href = "https://www.linkedin.com/in/hunorgered/"; } [
            (img {
              src = ./icons/linkedin.svg;
              alt = "";
              class = "icon";
            })
            (span "LinkedIn")
          ]
        ))
        (li (
          a { href = "https://github.com/hunorg"; } [
            (img {
              src = ./icons/github.svg;
              alt = "";
              class = "icon";
            })
            (span "GitHub")
          ]
        ))
        (li (
          a { href = "https://gitlab.com/hunorg"; } [
            (img {
              src = ./icons/gitlab.svg;
              alt = "";
              class = "icon";
            })
            (span "GitLab")
          ]
        ))
      ])
    ])

    (section [
      (h2 "Contact")
      (address (ul [
        (li (
          a { href = "https://matrix.to/#/@hunig:matrix.org"; } [
            (img {
              src = ./icons/matrix.svg;
              alt = "";
              class = "icon";
            })
            (span [
              "Matrix — "
              (code "@hunig:matrix.org")
            ])
          ]
        ))
        (li (
          a { href = "mailto:hunorgered@gmail.com"; } [
            (img {
              src = ./icons/email.svg;
              alt = "";
              class = "icon";
            })
            (span "Email — hunorgered@gmail.com")
          ]
        ))
      ]))
    ])

    (footer [
      "Built with "
      (a { href = "https://htnl.molybdenum.software/"; } (img {
        src = ./icons/htnl.svg;
        alt = "htnl";
        class = [
          "icon"
          "icon-wide"
        ];
      }))
      ", a Nix library for making websites. "
      (a { href = "https://github.com/hunorg/hunorg.com"; } "Source")
      " · "
      (a { href = "https://github.com/hunorg/hunorg.com/blob/main/LICENSE"; } "MIT")
      "."
    ])
  ])
]
|> document
|> (indexHtml: { htmlDocuments."index.html" = indexHtml; })
|> bundle
|> (
  bundle:
  runCommand "hunor-site"
    {
      nativeBuildInputs = [
        cowsay
        validator-nu
      ];
    }
    ''
      mkdir $out
      cp -r ${bundle}/* $out
      chmod u+w $out/index.html
      cow=$(cowsay -W 40 ${lib.escapeShellArg about} \
        | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' \
        | sed \
          -e 's|Elm|<a href="https://elm-lang.org/">Elm</a>|' \
          -e 's|Haskell|<a href="https://www.haskell.org/">Haskell</a>|' \
          -e 's|Nix/NixOS|<a href="https://nixos.org/">Nix/NixOS</a>|')
      substituteInPlace $out/index.html --replace-fail '@COW@' "$cow"
      vnu --Werror $out/index.html
    ''
)
