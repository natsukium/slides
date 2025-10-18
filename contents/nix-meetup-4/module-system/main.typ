#import "@preview/touying:0.5.3": *
#import themes.metropolis: *

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  header-right: [],
  footer: self => self.info.title,
  config-info(
    title: [Nix meetup \#4],
    subtitle: [モジュールシステム入門],
    author: [natsukium],
    date: [2025-10-18],
    institution: [Nix日本語コミュニティ],
    logo: image("./assets/nix-snowflake.svg", width: 40%),
  ),
)

#title-slide()

= はじめに

== Nixモジュールシステムとは

Nixモジュールシステムは、設定を宣言的に管理するためのフレームワーク

- NixOS や home-manager で使用される設定システム
- オプション宣言と設定値を分離
- 複数のモジュールを自由に組み合わせ可能
- 型による制約で設定を検証

例：

```nix
{
  programs.git.enable = true;
  virtualisation.docker.enable = true;
}
```

---

== モジュールシステムの利点

*従来の設定ファイル管理の問題：*

シェル設定ファイルでツールを設定する場合：
- シェルの設定ファイルに他ソフトウェアの初期化処理が混在
- パスの追加、環境変数の設定など責任が曖昧に
- ツールAの設定がツールBの存在を前提とする依存関係の管理が困難
- シェルを乗り換える際、各ツールの初期化処理を手動で移行する必要がある

*モジュールシステムによる解決：*

```nix
# starshipモジュールの例
{ config, ... }: {
  programs.bash.enable = true;
  programs.starship.enable = true;
}
```

---

```nix
{
  config = lib.mkIf programs.starship.enable {
    programs.bash.${initOption} = ''
      if [[ ! -f "$HOME/.config/starship.toml" ]]; then
        export STARSHIP_CONFIG=${settingsFile}
      fi
      eval "$(${cfg.package}/bin/starship init bash)"
    '';
  };
}
```

*モジュール内部での自動設定：*
- `starship.enable = true` にするだけで、bash初期化スクリプトに設定を自動追加
- `programs.bash.enable = false` なら、このbashrc設定は生成されない
- ツール固有の設定を各モジュールが管理し、シェル設定ファイルへの手動追加が不要

= 自己紹介

== natsukium

#slide(composer: (auto, 1fr))[
  #image("assets/natsukium.png", width: 60%)
][
  - 機械学習エンジニア
  - 最近はWebサービス開発でTypeScript/Rust
  - 四国在住
  - nixpkgsコミッター
  - Pythonのメンテナー
]

= モジュールの基本構造

== 3つの主要要素

```nix
{
  # 1. オプション宣言
  options = {
    programs.bash.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  # 2. 設定値
  config = mkIf config.programs.bash.enable {
    environment.systemPackages = [ pkgs.bashInteractive ];
    ...
  };
  # 3. 他のモジュールのインポート
  imports = [ ./another-module.nix ];
}
```

== 短縮構文

`config` しかない場合、トップレベルの `config` を省略可能

```nix
{
  programs.bash.enable = true;
}
```

普段何気なく書いているのはこの短縮構文

= モジュールとはなにか

== 設定のフレームワーク

モジュールシステムが提供する主要機能：

1. *NixOS や home-manager で使用される設定システム*
   - 宣言的な設定管理を実現
   - システム全体の設定を統一的に記述

2. *オプション宣言と設定値を分離*
   - オプション定義: 設定項目の型や制約を宣言
   - 設定値: 実際の値を記述
   - 関心の分離により保守性が向上

---

3. *複数のモジュールを自由に組み合わせ可能*
   - 関心ごとに設定をモジュール化
   - 複数ファイルにまたがる設定を1つのモジュールで完結

4. *型による制約で設定を検証*
   - Nixは動的型付け言語だが、ビルド時（derivation生成前）に型チェック
   - 実行時エラーではなくコンパイル時エラーとして検出
   - ポート番号、パスなど特定の制約を持つ型を定義可能

== 型による制約

```nix
{
  options.services.my-web-app.port = mkOption {
    type = types.port;  # 1-65535の範囲をチェック
    default = 8080;
  };

  # 不正な値は評価時にエラー
  config.services.my-web-app.port = 99999;  # Error!
}
```

---

https://github.com/NixOS/nixpkgs/blob/release-25.05/lib/types.nix

```nix
port = ints.u16;  # 0-65535の範囲制約
u16 = unsign 16 65536;
unsign = bit: range:
  between 0 (range - 1);  # 範囲チェック関数を適用

between = lowest: highest:
  assert lowest <= highest;
  addCheck int (x: x >= lowest && x <= highest)
  // {
    name = "intBetween";
    description = "integer between ${toString lowest} and ${toString highest} (both inclusive)";
  };
```

= どうやって実現してるのか

== evalModules - モジュールシステムの心臓部

```nix
lib.evalModules {
  modules = [ /* モジュールのリスト */ ];
  specialArgs = { /* 追加の引数 */ };
}
```

*処理フロー：*
1. モジュール片を収集
2. 優先度を見ながらマージ
3. 一つの巨大な attrset を生成

---

生成されたattrsetをどう扱うかはモジュールの責務の外
（nixos-rebuild, home-manager などの仕事）

*具体例：*
- `environment.systemPackages` → パスに追加
- `environment.etc."foo".text` → `/etc/foo` にファイル配置
- `systemd.services.myapp` → systemd unit ファイル生成
- `users.users.alice` → `/etc/passwd`, `/etc/shadow` に反映

== 型ごとのマージ戦略

```nix
# int/str/bool: 重複時はエラー（mergeEqualOption）
# moduleA.nix
config.value = 10;
# moduleB.nix
config.value = 20;  # Error: conflict!

# list: 連結（concat）
# moduleA.nix
config.list = [ 1 2 ];
# moduleB.nix
config.list = [ 3 4 ];  # => [ 1 2 3 4 ]

# attrset: 再帰的にマージ
# moduleA.nix
config.attrs.a = 1;
# moduleB.nix
config.attrs.b = 2;  # => { a = 1; b = 2; }
```

== モジュールシステムを使うプロジェクト

- NixOS
- home-manager
- nix-darwin
- flake-parts
- treefmt-nix
- devenv

= evalModules の詳細

== 関数シグネチャ

```nix
evalModules = {
  modules,              # 必須: モジュールのリスト
  prefix ? [],          # オプションパスのプレフィックス
  specialArgs ? {},     # 特別な引数
}: { config, options, ... }
```

実装場所：https://github.com/NixOS/nixpkgs/blob/bb9da33c6283f6e9c5265ff92b5eee5d815944dd/lib/modules.nix#L84-L367

== コア処理の抜粋

```nix
evalModules = { modules, specialArgs ? {}, ... }:
  let
    # 入力: モジュールのリスト
    # 1. 収集: imports を再帰的に解決
    collected = collectModules modules;
    # 2. マージ: オプション宣言と設定定義を統合
    merged = mergeModules prefix (reverseList collected.modules);
    # 3. 評価: オプション宣言から最終的な設定値を抽出
    options = merged.matchedOptions;  # マージ済みのオプション宣言
    # 宣言済みオプションから設定値を生成
    config = mapAttrsRecursiveCond
      (v: !isOption v)       # オプション型でない属性まで再帰
      (_: v: v.value)        # 各オプションのvalue属性を抽出
      options;
    # 出力: 評価済みの設定とオプション
  in { inherit config options; }
```

== 処理の流れ

```
1. モジュール収集（collectModules）
   - imports を再帰的に解決
   - disabledModules でフィルタリング
   ↓
2. モジュールマージ（mergeModules）
   - オプション宣言を統合
   - 設定定義を統合
   ↓
3. 評価
   - プロパティ（mkIf, mkMerge）を処理
   - 優先度でフィルタリング
   - 型チェックとマージ
```

== 優先度システム

```nix
# 優先度（小さいほど高い）
config.example = mkForce "a";  # 優先度 50
config.example = "b";          # 優先度 1000

# result: b (mkForce が最優先)
```

最も高い優先度（最小の数値）の定義のみが保持される

== 条件とマージ

```nix
# 条件付き定義
config = mkIf config.services.enable {
  systemd.services.myapp = { ... };
};

# 複数定義のマージ
config = mkMerge [
  { programs.bash.enable = true; }
  (mkIf isLinux { programs.zsh.enable = true; })
];
```

== 簡単な評価例

*str型の場合：*

```nix
let
  result = lib.evalModules {
    modules = [
      {
        options.example = mkOption {
          type = types.str;
        };
        config.example = "hello";
      }
      { config.example = mkForce "world"; }
    ];
  };
in
result.config.example
# => "world"
```

---

*list型の場合：*

```nix
let
  result = lib.evalModules {
    modules = [
      {
        options.example = mkOption {
          type = types.listOf types.str;
        };
        config.example = [ "hello" ];
      }
      { config.example = [ "world" ]; }
    ];
  };
in
result.config.example
# => [ "hello world" ]
```

= ゼロからはじめるモジュール

== 最小構成

```nix
let
  modules = [
    {
      options.message = lib.mkOption {
        type = lib.types.str;
        default = "hello";
      };
    }
    { config.message = "world"; }
  ];

  result = lib.evalModules { inherit modules; };
in
builtins.toJSON { inherit (result.config) message; }
# => {"message":"world"}
```

== JSONファイル生成

```nix
let
  modules = [
    # 関数形式のモジュール（lib を引数として受け取る）
    { lib, ... }: {
      options.message = lib.mkOption {
        type = lib.types.str;
        default = "hello";
      };
    }
    { config.message = "world"; }
  ];

  result = lib.evalModules { inherit modules; };
in
pkgs.writeText "config.json"
  (builtins.toJSON { inherit (result.config) message; })
```

---

```bash
$ nix eval --json --file example.nix | jq
{
  "message": "world"
}
```

= 実例: mcp-servers-nix

== mcp-servers-nixとは

*mcp-servers-nix* は、MCPサーバーの設定をNixモジュールシステムで管理するプロジェクト

- natsukiumが開発・メンテナンス
- MCPサーバー設定の課題を解決
- 宣言的な設定管理とセキュリティ向上を実現
- 複数のMCPクライアント（Claude Desktop、Zedなど）に対応

#place(bottom + right, text(size: 8pt)[
  *参考*: https://zenn.dev/natsukium/articles/f010c1ec1c51b2
])

== MCPとは

*Model Context Protocol (MCP)*

- LLMから外部ツールやコンテキストを呼び出すプロトコル
- クライアントはサーバーに接続するための設定が必要

---

*主な課題：*
1. *ランタイム管理の複雑さ*
   - Node.js、Pythonなど複数のランタイムが必要
2. *認証情報の管理*
   - APIトークンを設定ファイルに直接記述
   - バージョン管理への誤コミットリスク
3. *サプライチェーンセキュリティ*
   - npx/uvxは最新版を自動取得（タグ改ざんリスク）
   - パッケージ整合性検証の欠如
4. *設定の再現性*
   - 設定の共有が困難、デバイス間での一貫性維持が難しい

#place(bottom + right, text(size: 8pt)[
  *参考*: https://zenn.dev/natsukium/articles/f010c1ec1c51b2
])

== 一般的な設定例

Claude Desktop の場合（JSON）：

```json
{
  "mcpServers": {
    "github": {
      "command": "/path/to/github-mcp-server",
      "args": ["stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"
      }
    },
    "serena": {
      "command": "npx",
      "args": ["-y", "@baselinehq/serena", "--enable-web-dashboard=false"],
    }
  }
}
```

問題：
- APIキーがべた書きでバージョン管理に含めづらい
- バージョン固定が困難（npx -yは常に最新版を取得）
- クライアントごとに設定キーが異なる（Claude Desktop、Zedなど）

== Nixで解決

```nix
{ pkgs, ...}: {
  programs.github = {
    enable = true;
    passwordCommand.GITHUB_PERSONAL_ACCESS_TOKEN = [ "gh" "auth" "token" ];
  };

  programs.serena = {
    enable = true;
    enableWebDashboard = false;
    extraPackages = [ pkgs.pyright pkgs.nixd ];
  };
}
```

*実現できること：*
- パスワードコマンドで秘匿情報を動的に注入
- ファイル参照により設定とクレデンシャルを分離
- クライアント間の設定形式の違いを吸収（Claude Desktop、Zedなど）
- パッケージバージョンを宣言的に固定

*ファイル出力形式の柔軟性：*
```nix
# JSON/YAML/TOML形式に変換可能
pkgs.formats.json {}.generate "config.json" config
pkgs.formats.yaml {}.generate "config.yaml" config
pkgs.formats.toml {}.generate "config.toml" config
```

モジュールのインターフェース自体は変わらないため、ユーザー間やツール間での再利用性が高まる

*パッケージ存在の保証：*
- パッケージマネージャーだからこそ、パッケージの存在を保証
- バージョンと設定の一貫性を管理
- モジュールはアトリビュートセットを生成するだけなので、そのアトリビュートセットを柔軟に操作可能
  （例：特定のキーを使ってパッケージをラップ）

== 実装の流れ

https://github.com/natsukium/mcp-servers-nix/blob/3e5a2084080219b782ed31b51b29d0781ccb89ca/lib/default.nix

== mcp-servers-nixで実現できること

*静的なJSONファイルとの違い：*

1. *パッケージマネージャーとしての強み*
   - パッケージの存在を型システムで保証
   - バージョンと設定の一貫性を管理
   - ラッパースクリプトで実行時の動作を拡張
   - 依存関係を宣言的に追加・管理

2. *設定の抽象化による柔軟性*
   - パスワードコマンドで秘匿情報を動的に注入
   - ファイル参照により設定とクレデンシャルを分離
   - 複数の形式（JSON/YAML/TOML）への柔軟な変換

3. *Nixエコシステムとの統合*
   - NixOS、home-manager、nix-darwinとの統合
   - agenix/sopsなどのシークレット管理との統合
   - gitで設定を管理、flakeで他者と共有

= まとめ

== モジュールシステムで得られるもの

1. *宣言的な設定管理*
   - 設定を一箇所で管理、再現性を確保
   - evalModules一つで収集 → マージ → 評価を実現

2. *型による安全性*
   - 実行前に設定の妥当性を検証
   - カスタム型で柔軟な制約を定義可能

3. *柔軟な組み合わせと制御*
   - mkDefault, mkForce, mkIf, mkMerge による細かい制御
   - モジュールの組み合わせで複雑な設定を構成

4. *広範な採用と実績*
   - NixOS, home-manager, treefmt-nix, flake-parts...
   - 実用的なプロジェクトで活用されている

5. *コミュニティへの貢献がしやすい*
   - NixOS、home-managerへのモジュール追加が容易
   - 独自のモジュールシステムも簡単に構築可能
   - 設定を共有し、コミュニティに還元できる

== 参考リソース

- module systemの実装
  https://github.com/NixOS/nixpkgs/blob/bb9da33c6283f6e9c5265ff92b5eee5d815944dd/lib/modules.nix

- NixOS Manual
  https://nixos.org/manual/nixos/stable/#sec-writing-modules

- tmux-nixの実装を通して学ぶNixOSモジュール (Nix meetup #3)
  https://speakerdeck.com/momeemt/tmux-nixnoshi-zhuang-wotong-sitexue-bunixosmoziyuru
  momeemtさんによるNixOSモジュール開発の実践的な解説
