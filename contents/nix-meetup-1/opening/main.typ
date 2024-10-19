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
    title: [Nix meetup \#1],
    subtitle: [オープニング],
    author: [natsukium],
    date: [2024-10-26],
    institution: [Nix日本語コミュニティ],
    logo: image("./assets/nix-snowflake.svg", width: 40%),
  ),
)

#title-slide()

#focus-slide[
  ハッシュタグ

  #text(size: 60pt)[\#nix_ja]
]

= はじめに

== 出席登録


#slide(composer: (1fr, auto))[
  connpass にて出席登録をお願いします

  #image("./assets/nix-snowflake.svg", alt: "test", width: 40%, height: 40%)
][


  #align(
    center,
    [
      URL はこちら

      #logo-qr-code(
        "https://nix-ja.connpass.com/event/330557",
        image("./assets/nix-snowflake.svg", width: 40%, height: 40%),
        rect(width: 40%, height: 40%, fill: white),
        size: 8cm,
        options: (
          option-1: 4,
          output-options: (barcode-dotty-mode: true),
          dot-size: 1.1,
        ),
      )


      https://nix-ja.connpass.com/event/330557
    ],
  )

]

= 会場説明

=

==
- Nix を使ったことがある人

#pause

- Nix を日常的に使っている人

#pause

- NixOSを使っている人

#pause

- Home Manager や Nix Darwin を使っている人

= 終わりに

==

気になることがあれば Nix 日本語コミュニティの Discord へ！

まだ参加していない方はこちらからご参加ください

#logo-qr-code(
  "https://discord.com/invite/TYytzedtbe",
  image("./assets/nix-snowflake.svg", width: 40%, height: 40%),
  rect(width: 40%, height: 40%, fill: white),
  size: 8cm,
  options: (
    option-1: 4,
    output-options: (barcode-dotty-mode: true),
    dot-size: 1.1,
  ),
)

https://discord.com/invite/TYytzedtbe

==

Have fun!

= タイムテーブル <touying:hidden>

== タイムテーブル
#text(size: 10pt)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    fill: (_, y) => if y == 0 {
      gray
    },
    table.header(
      [time],
      [presenter],
      [content],
    ),

    "13:00", "", "開場",
    "13:30", "natsukium", "オープニング",
    "13:45", "asa1984", "Nix/NixOSの学習パスとNixのメンタルモデルについて",
    "14:05", "ShunDeveloper", "Nix初心者がGetting Startedしてみた的なことを話します",
    "14:25", "sho19921005", "「NixOSライブインストール（仮）」",
    "14:45", "yasunori-kirin0418	", "nixの設定分割のやりかたと、dotfilesとの組合せについて",
    "15:05", "", "休憩",
    "15:25", "natsukium", "nixpkgsにコントリビュートしよう",
    "15:45", "ROCKTAKEY", "GNU GuixとNixとの比較",
    "16:05", "ymgyt", "deploy-rsでNixをdeploy",
    "16:25", "_hiroqn", "社内ツール配布系",
    "16:40", "", "懇親会(軽食)",
    "18:10", "", "クロージング",
  )
]
