# 200-OK - HTTPステータスコードクイズゲーム

HTTPステータスコードを学べる4択クイズゲームです。Ruby2Dを使用して開発されています。

<img width="790" height="592" alt="image" src="https://github.com/user-attachments/assets/a91c7025-aec5-42ca-85f6-fc16caa2bd70" />

<img width="794" height="592" alt="image" src="https://github.com/user-attachments/assets/ef477744-e88d-4249-8b6b-fc773551b66e" />

## 必要環境

- Ruby 3.0以上
- Ruby2D gem

## インストール

```bash
$ git clone git@github.com:hnegishi/200-OK.git
```

```bash
$ bundle install
```

## 起動方法

```bash
$ ruby main.rb
```

## ゲームモード

### チャレンジモード
- 10問のクイズに挑戦
- 全問正解を目指そう
- ハイスコアが記録されます

### エンドレスモード
- 1回ミスしたら終了の無限チャレンジ
- どこまでスコアを伸ばせるか挑戦
- ハイスコアが記録されます


## 機能

- HTTPステータスコード約40種類を収録
- 10秒の制限時間付きクイズ
- 回答後に詳細な解説を表示
- HTTPステータスコード辞書機能
- ハイスコア記録機能
- BGM再生（ミュート可能）

## プロジェクト構成

```
200-OK/
├── main.rb                    # エントリポイント
├── Gemfile
├── README.md
├── assets/
│   ├── audio/
│   │   └── bgm.mp3           # BGMファイル
│   └── images/
│       ├── image.png         # タイトルロゴ
│       ├── mucis-play.svg    # 音声再生アイコン
│       └── mucis-mute.svg    # ミュートアイコン
├── data/                      # ゲームデータ（自動生成）
│   ├── highscores.json       # ハイスコア
│   └── audio_settings.json   # 音声設定
└── lib/
    ├── constants.rb          # 定数定義
    ├── http_data.rb          # HTTPステータスコードデータ
    ├── button.rb             # ボタンUIコンポーネント
    ├── mode_card.rb          # モード選択カード
    ├── question.rb           # クイズ問題ロジック
    ├── scene.rb              # シーン基底クラス
    ├── scene_manager.rb      # シーン管理
    ├── score_manager.rb      # スコア管理
    ├── audio_manager.rb      # BGM管理
    ├── game.rb               # メインゲームクラス
    └── scenes/
        ├── menu_scene.rb      # メニュー画面
        ├── playing_scene.rb   # ゲームプレイ画面
        ├── game_over_scene.rb # 結果画面
        └── dictionary_scene.rb # HTTPステータスコード辞書画面
```
