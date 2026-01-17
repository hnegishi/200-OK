# 200-OK - HTTPステータスコードクイズゲーム

HTTPステータスコードを学べる4択クイズゲームです。Ruby2Dを使用して開発されています。

<img width="793" height="593" alt="image" src="https://github.com/user-attachments/assets/df43353c-1f4f-4952-9912-7785c4d5a87f" />

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
- 3回ミスするまで続く無限チャレンジ
- どこまでスコアを伸ばせるか挑戦
- ハイスコアが記録されます


## 機能

- HTTPステータスコード約40種類を収録
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
        ├── menu_scene.rb     # メニュー画面
        ├── playing_scene.rb  # ゲームプレイ画面
        └── game_over_scene.rb # 結果画面
```
