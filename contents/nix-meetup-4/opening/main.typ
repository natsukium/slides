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
  header-right: [],
  footer: self => self.info.title,
  config-info(
    title: [Nix meetup \#4],
    subtitle: [オープニング],
    date: [2025-10-18],
    institution: [Nix日本語コミュニティ],
    logo: image("./assets/nix-snowflake.svg", width: 40%),
  ),
)

#title-slide()

#focus-slide[
  ハッシュタグ

  #text(size: 60pt)[\#nix_ja]
]

= 主催者紹介

== natsukium

#slide(composer: (1fr, 2fr))[
  #align(center + horizon)[
    #image("./assets/natsukium-icon.jpeg", width: 80%)
  ]
][
  - GitHub: #link("https://github.com/natsukium")[\@natsukium]
  - nixpkgs committer

  本日の発表:
  - モジュールシステム入門
]

== たけてぃ

#slide(composer: (1fr, 2fr))[
  #align(center + horizon)[
    #image("./assets/takeokunn-icon.jpeg", width: 80%)
  ]
][
  - GitHub: #link("https://github.com/takeokunn")[\@takeokunn]
  - Tokyo Emacs 勉強会主催
  - Software Design にて
  「パッケージマネージャーNix入門」連載中
  #align(right)[
    #image("./assets/sd.jpeg", height: 50%)
  ]
]

---

#align(
  center,
  [
    10/31 開発環境自慢Night で nixos-container について登壇予定

    #image("./assets/techbrew.png", height: 80%)

    #link("https://findy.connpass.com/event/372055/")[https://findy.connpass.com/event/372055/]
  ],
)

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
        "https://nix-ja.connpass.com/event/369476",
        image("./assets/nix-snowflake.svg", width: 40%, height: 40%),
        rect(width: 40%, height: 40%, fill: white),
        size: 8cm,
        options: (
          option-1: 4,
          output-options: (barcode-dotty-mode: true),
          dot-size: 1.1,
        ),
      )

      https://nix-ja.connpass.com/event/369476
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
        "https://docs.google.com/presentation/d/1zZVJMNTtUAlDViO1I0rT4ZsvNm6lWjUtPJL8kVqoJ3Q/edit",
        image("./assets/nix-snowflake.svg", width: 40%, height: 40%),
        rect(width: 40%, height: 40%, fill: white),
        size: 8cm,
        options: (
          option-1: 4,
          output-options: (barcode-dotty-mode: true),
          dot-size: 1.1,
        ),
      )


      https://docs.google.com/presentation/d/1zZVJMNTtUAlDViO1I0rT4ZsvNm6lWjUtPJL8kVqoJ3Q/edit
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

Nix の国際的なイベントの代表的なものに #link("https://nixcon.org")[*NixCon*] がある

NixCon は2015年からほぼ毎年欧州で行われている Nix の公式のカンファレンスである

今年(2025年)はスイスで開催された (#link("https://2025.nixcon.org")[2025.nixcon.org])

過去のアーカイブは #link("https://www.youtube.com/c/NixCon")[YouTube] から視聴可能

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

== 日本のミートアップ

過去には #link("https://www.meetup.com/tokyo-nixos-meetup")[*Tokyo NixOS*] という公式ページに載るコミュニティが存在していたが、2018年6月を最後に活動を停止

#pause

そして2024年10月、6年振りとなる *Nix meetup \#1* を開催

#pause

その後も継続的に開催し、今回で *4回目*

- \#1: 2024/10/26 (56人参加, 東京)
- \#2: 2025/03/09 (54人参加, 東京)
- \#3: 2025/05/24 (18人参加, 大阪)
- \#4: 2025/10/18 (今日！)

---

日本で Nix のコミュニティをもっと盛り上げていきましょう！

== nix meetup \#4 の参加者統計

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
          [Nix歴],
          [人数],
        ),

        "〜1年", "14人",
        "〜5年", "17人",
        "〜10年", "2人",
        "10年〜", "1人",
      )
    ],
  )
][
  - 総参加者数: 34人（登壇8名 + 一般26名）
  - 参加者の約4割が1年未満のユーザー
  - 経験者層も充実
]

= 本イベントの概要

== タイムテーブル
#text(size: 9pt)[
  #table(
    columns: (auto, auto, auto),
    inset: 8pt,
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
    "13:40", "ryuryu55", "Nixで作るZenn執筆環境",
    "14:00", "Omochice", "チームで nix を使うために考えてること（仮）",
    "14:20", "r-aizawa", "なぜか連載を添削することになった件 ~r-aizawa 編~",
    "14:40", "natsukium", "モジュールシステム入門",
    "15:00", "", "休憩",
    "15:20", "Shunsuke Tsuchiya", "NixOS を導入してみた",
    "15:40", "comavius", "Moonbit 製プロジェクトを Nix でビルドするまで",
    "16:00", "momeemt", "卒研 or NixCon2025感想 or ツールチェーンの紹介",
    "16:20", "M. Ian Graham", "理想（？）の動画鑑賞環境を NixOS で作ってみた",
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

