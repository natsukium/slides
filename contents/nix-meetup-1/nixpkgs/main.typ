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
  footer: self => self.info.institution,
  config-info(
    title: [nixpkgs にコントリビュートしよう],
    author: [natsukium],
    date: [2024-10-26],
    institution: [Nix meetup \#1],
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
  config-common(show-notes-on-second-screen: right),
)

#title-slide()

= Outline <touying:hidden>

#outline(depth: 2)

= Introduction <touying:hidden>

== Introduction

#slide[
  #align(
    center,
    [
      #logo-qr-code(
        "https://keyoxide.org/dccb2d69e06eeaa48904f8a12d5add7530f56a42",
        image("./assets/natsukium.png", width: 40%, height: 40%),
        rect(width: 30%, height: 30%, fill: white),
        size: 7cm,
        options: (
          option-1: 4,
          output-options: (barcode-dotty-mode: true),
          dot-size: 1.1,
        ),
      )

      https://keyoxide.org/dccb2d69e06eeaa48904f8a12d5add7530f56a42
    ],
  )
][
  ```nix
  {
    name = "natsukium";
    job = [ "MLE" "SWE" ];
    xxx = "NixOS/nixpkgs committer";
    yyy = "nixpkgs python team";
  }
  ```

  #speaker-note[
    natsukiumと申します
    今日はこのnix meetupを主催するために西日本にある島からやってきました
    東京の企業で機械学習エンジニアとして働いていますが、最近はkotlinを使ったwebアプリケーションの開発に従事しています
    趣味はパッケージングで新しいパッケージをnixpkgsに追加したりビルド環境を改善したりしています

    nixpkgsではコミッターをやっていて、他にもpython teamに属していてnixpkgsの基盤になるPythonインタープリターのメンテナンスや膨大な数のライブラリを含むエコシステム全体のお守りをしています
  ]
]

---

#slide[
  #image("assets/contributors.png")
][
  - 2003年からの総コミット数では歴代25番目
  - 直近2年では大体10番目くらい

  #speaker-note[
    nixpkgsへのコミットの数でいうと全期間において25番目くらい、直近2年ではだいたい10番目くらいのコミットをしているのでもしかすると見かけたことがある方もいらっしゃるかもしれません
  ]
]

== nixpkgs とは

nixpkgs を使ったことがありますか？

#pause

#image("./assets/repology.svg")

#speaker-note[
  ご存知の通り、nixpkgsは世界最大のパッケージレポジトリでありrepologyによると2024年10月時点で100,000弱のソフトウェアがパッケージングされています
  パッケージの数え方は難しく、一概に数だけを比較することはできないが、なんでもあると言われているarch linux(AUR含む)のパッケージ数をゆうに超えており、実際利用していてもパッケージがなくて困るということはかなり少ないのではないでしょうか

  私が初めてNixに出会ったのはまだNixがトレンドになる前2017年の暮れ頃でしたが、この頃はまだまだパッケージ数が少なく、Nix/NixOSを快適に利用できるとは言い難い状況だったと記憶しています

  今ではその利点を見込まれてdocker debugやproject idx, replitなどの製品に組み込まれるほどになりました
]

---

#image("./assets/repology-stats.png")

---

nixpkgs にはなんでもあるな

#speaker-note[
  このように最近ではnixpkgsにはなんでもあるとよく言われますが本当は違います
]

#focus-slide[
  なんでもはないわよ

  ないものはパッケージングするだけ

  #speaker-note[
    前置きが長くなりましたが、今日はより快適にnixを使えるよう、nixpkgsにコントリビュートしていく方法を解説しようと思います
  ]
]

= Case Study

== case1 新規パッケージを追加したい

パッケージの受け入れ基準

https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md

#pause
- パッケージが一般的に使えるものであるか
  - 開発初期段階のものやじきに放置されるもの
#pause
- ライセンスが明確であるか
  - ソースコードがオープンになっているからといって再配布が可能であるとは限らない
#pause
- 多くの人に使われうるものか
  - 特定のプロジェクトに特化したヘルパーツールなど
#pause
- メンテナンスする気があるか
  - 少なくとも1リリースサイクル(6ヶ月)はメンテするのが望ましい

---

0. 少し長いが、 nixpkgs のCONTRIBUTION.md には必ず目を通しておく
- ドキュメントの修正や新規項目の追加もよくあるので、定期的に見返すと良い
- pkgs/README.md や 実装言語ごとのドキュメントにも目を通すのが望ましい

1. issue や PR を検索し、既に進行中のものがないか確認

2. nixpkgs をクローンし、masterブランチから新しいブランチを切る

3. パッケージを追加し、ビルドが通ることを確認
- パッケージを追加するときには #link("https://github.com/nix-community/nix-init")[nix-init] を使うのが便利

#speaker-note[
  初めてのコントリビューションの際はもちろん、慣れてきた頃にも見返すとまた新たな発見があるはず。
  私のようにコミッターとしてnixpkgsに深く関わっていてもよく見返している
]

---

=== メンテナーになる方法

新規パッケージを追加する際には自分をメンテナーにすることが求められる


== case2 古くなっているパッケージをアップデートしたい

新規パッケージの追加と手順は同じ

多くの場合、パッケージの追加よりもアップデートのほうが簡単なことが多い

機械的にバージョンアップするだけでなく、changelogやdiffを確認すること

#speaker-note[

]

=== 便利なツール

nix-update: パッケージのアップデートチェック、ハッシュの更新、コミットの生成など、
nixpkgs-review

=== 意図せずリビルドが多くなったら

Nix はその性質上、パッケージに更新があるとそれに依存する他のすべてのパッケージも更新される

末端に近いパッケージであればそれらのリビルドの負荷も大きくないため変更はすべて master ブランチへマージされる
一方リビルドに負荷のかかる変更、 nixpkgs では一般に 1,500 以上のリビルドが発生するものは staging ブランチへマージされ、
ある程度変更がたまってから一気にビルドを行い

https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#rebasing-between-branches-ie-from-master-to-staging

```bash
git rebase --onto upstream/staging... upstream/master
git push origin feature --force-with-lease
```


== case3 壊れているパッケージを修正したい

次のセクションで解説

== Help! PRがレビューしてもらえない、どうしたらいい？

= Zero Hydra Failure (ZHF)

#speaker-note[
  NixOSは年に2回、安定版のリリースが行われます
  現在のリリースサイクルは5月末と11月末であり、現行のstableが24.05 uakari, そしてきたる1ヶ月後に24.11 vicunaがリリースされます
  リリースプロセスにはいろいろとあるのですが、その中でユーザーが貢献できる非常に重要なプロセスがあります
]

---

#speaker-note[
  ZHFはリリースのおよそ3週間前から行われるプロセスで、masterブランチ上で破損しているパッケージを修正し、リリースブランチの品質をあげる作業です
  この期間には通常よりも非常に多くのPRが提出されそれらのレビュー、マージが優先して行われるようになる
  このようにZHFの期間はかなり活発になるので初めてのコントリビュートにも適している
]

== やりかた

= 最後に

#speaker-note[
  nixpkgsへの貢献の敷居がさがったでしょうか？
  今回は時間の都合上簡単なパッケージを使ってデモを行いました
  ソフトウェアによってはパッケージングが難しいものもある
  なにか困ったことがあればコミュニティでたずねてください
  私でもいいし、日本語コミュニティでもいいし、GitHubやdiscourseなどで直接聞いてもいい
]

#focus-slide[
  パッケージ数100,000を目指していきましょう！
]
