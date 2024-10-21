#import "@preview/touying:0.5.3": *
#import "@preview/tiaoma:0.2.1": qrcode
#import themes.metropolis: *

#let logo-qr-code(content, image, bg, size: auto, ..args) = {
  box(
    width: size,
    height: size,
    {
      qrcode(content, width: size, height: size, ..args)
      place(center + horizon, bg)
      place(center + horizon, image)
    },
  )
}

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-info(
    title: [nixpkgs にコントリビュートしよう],
    author: [natsukium],
    date: [2024-10-26],
    institution: [Nix日本語コミュニティ],
    logo: logo-qr-code(
      "https://natsukium.github.io/slides/nix-meetup-1/nixpkgs",
      image("./assets/nix-snowflake.svg", width: 30%, height: 30%),
      rect(width: 30%, height: 30%, fill: white),
      size: 3cm,
      options: (
        option-1: 4,
        output-options: (barcode-dotty-mode: true),
        dot-size: 1.1,
      ),
    ),
  ),
)

#title-slide()

= Outline <touying:hidden>

#outline()

= 自己紹介 <touying:hidden>

== 自己紹介

#slide[
  #logo-qr-code(
    "https://github.com/natsukium",
    image("./assets/natsukium.png", width: 40%, height: 40%),
    rect(width: 30%, height: 30%, fill: white),
    size: 7cm,
    options: (
      option-1: 4,
      output-options: (barcode-dotty-mode: true),
      dot-size: 1.1,
    ),
  )

  https://github.com/natsukium

][
  name: natsukium

  job: MLE/SWE

  NixOS/nixpkgs committer

  nixpkgs python team
]

== First Slide

Hello, Touying!

#pause

Hello, Typst!

#pause

Hello Nix Meetup \#1 !

= Zero Hydra Failure (ZHF)
