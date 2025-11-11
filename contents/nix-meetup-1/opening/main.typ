#import "@preview/touying:0.5.3": *
#import "@preview/tiaoma:0.3.0": qrcode
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
  header-right: [],
  footer: self => self.info.title,
  config-info(
    title: [Nix meetup \#1],
    subtitle: [オープニング],
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

#slide(composer: (auto, auto))[
  #align(
    center,
    [
      connpass にて出席登録をお願いします

      #image("./assets/connpass.png", width: 100%)
    ],
  )
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

== ポジションペーパー

#slide(composer: (auto, auto))[
  #align(
    center,
    [
      #image("./assets/position-paper.png", width: 100%)
    ],
  )
][
  #align(
    center,
    [

      #logo-qr-code(
        "https://docs.google.com/presentation/d/1vIL0cI6ilUf0N7edkS5G3QR8HBja_dflJzOSi0KL4n4/edit?usp=sharing",
        image("./assets/nix-snowflake.svg", width: 40%, height: 40%),
        rect(width: 40%, height: 40%, fill: white),
        size: 8cm,
        options: (
          option-1: 4,
          output-options: (barcode-dotty-mode: true),
          dot-size: 1.1,
        ),
      )


      https://docs.google.com/presentation/d/1vIL0cI6ilUf0N7edkS5G3QR8HBja_dflJzOSi0KL4n4/edit?usp=sharing
    ],
  )
]

= 会場説明

= オープニングセッション

==

- Nix を使ったことがある人

#pause

- Nix を日常的に使っている人

#pause

- `nix develop` や `nix-shell` を使ってプロジェクトを管理している人

#pause

- NixOSを使っている人

#pause

- Home Manager や nix-darwin を使っている人

#pause

- Nix をプロダクションに導入している人

#pause

- Nix を CI で使っている人

---

= Nix meetup 開催の経緯

== Nixのイベント

Nix の国際的なイベントの代表的なものに #link("https://2024.nixcon.org")[*NixCon*] がある

NixCon は2015年からほぼ毎年欧州で行われているNix の公式のカンファレンスであり、
今年は10月25日から27日までドイツのベルリンで開催される

https://www.youtube.com/watch?v=oAzkHpSWhaI

#pause

NixConに参加するためにベルリンに行くかこのNix meetupに参加するために東京に行くかで迷った人も多いのでは？

== 海外のミートアップ

#align(
  center,
  [
    #image("./assets/discourse.png", height: 90%)

    https://discourse.nixos.org/c/events/13
  ],
)

---

#align(
  center,
  [
    #image("./assets/meetups.png", height: 90%)

    https://nixos.org/community
  ],
)

#speaker-note[
  世界に目を向けると様々な国や地域で活発にミートアップが開催されている
  私個人の願いではあるが、このミートアップを継続していってこの会をそれらと並ぶ存在にしたい
]

== 日本のミートアップ

日本にも公式ページに載るほどのコミュニティが存在している

#speaker-note[
  第一回目にして、もうこのnix meetupが認知されているのでしょうか？
]

#pause

その名も #link("https://www.meetup.com/tokyo-nixos-meetup")[*Tokyo NixOS*]

#pause

しかし Tokyo NixOS は2018年6月を最後に活動を停止

#focus-slide[
  日本において 6 年振りとなる Nix のイベントを開催！
]

== nix meetup \#1 の参加者統計

#slide[
  #align(
    center,
    [#table(
        columns: (auto, auto),
        inset: 10pt,
        align: horizon,
        fill: (_, y) => if y == 0 {
          gray
        },
        table.header(
          [年数],
          [人数],
        ),

        "1年未満", "52人",
        "1~5年", "13人",
        "5年以上", "2人",
      )
    ],
  )
][
  参加者の8割弱が1年未満のユーザー
]

---

日本で Nix のコミュニティをもっと盛り上げていきましょう！

= 本イベントの概要

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
    "14:25", "yasunori-kirin0418	", "nixの設定分割のやりかたと、dotfilesとの組合せについて",
    "14:45", "haruki7049", "Nix Overlayの作成の仕方",
    "15:05", "", "休憩",
    "15:25", "natsukium", "nixpkgsにコントリビュートしよう",
    "15:45", "take_", "nix-shell+org-modeで文芸的プログラミング",
    "16:05", "ymgyt", "deploy-rsでNixをdeploy",
    "16:25", "_hiroqn", "社内ツール配布系",
    "16:40", "", "懇親会(軽食)",
    "18:10", "", "クロージング",
  )
]

== 質問や感想は Discord へ

気になることがあれば Nix 日本語コミュニティの Discord へ！

まだ参加していない方はこちらからご参加ください

#align(
  center,
  [#logo-qr-code(
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
  ],
)

==

Have fun!

