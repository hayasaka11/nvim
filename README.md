# Neovim 設定

Neovim 0.11 以降向け。外部プラグインなしで、標準のファイル一覧・LSP・補完を使います。
Leader はスペースです。

| キー | 操作 |
| --- | --- |
| Space w | 保存 |
| Space e | ファイル一覧 |
| Space bn / bp | 次 / 前のバッファ |
| Ctrl-h / j / k / l | 分割ウィンドウ移動 |
| Esc（ノーマルモード） | 検索ハイライト解除 |
| Tab（挿入モード） | 補完 / 次の候補。行頭の空白ではインデント |
| Shift-Tab | 前の候補 / インデントを減らす |
| Ctrl-y / Ctrl-e（補完中） | 確定 / 補完を閉じる |
| gd / gr / K | 定義 / 参照 / ホバー（LSP） |
| Space rn / ca | 名前変更 / コードアクション（LSP） |
| Space d | 診断の詳細 |
| [d / ]d | 前 / 次の診断 |
| Space f | フォーマット（対応LSPのみ） |
| Space q | Quickfixを開く |

括弧とクオートは自動で閉じます。同じ閉じ文字を入力すると先に進み、
空のペア内で Backspace を押すと両方を削除します。
Markdown は折り返しと箇条書きの継続を有効にしています。

## LSP

PATH にあるサーバーのみ有効になります。インストールは自動では行いません。
インストール後は Neovim を再起動してください。

| 言語 | 実行ファイル |
| --- | --- |
| Lua | lua-language-server |
| TypeScript / JavaScript | typescript-language-server（typescript も必要） |
| Python | pyright-langserver |

接続の確認は `:checkhealth vim.lsp`。対応サーバーのトリガー文字で補完が開きます。
LSP のないバッファでは Tab で標準のキーワード補完を使います。
クリップボード共有には OS 側の provider が必要です（`:checkhealth vim.provider`）。

## ファイル

- `lua/options.lua`: 表示・検索・インデント・永続Undo
- `lua/autocmds.lua`: ファイル種別の設定・ヤンクのハイライト
- `lua/keymaps.lua`: 基本キー操作
- `lua/editing.lua`: 括弧入力・補完キー
- `lua/lsp.lua`: LSP共通設定・診断・補完
- `lsp/`: 言語サーバーごとの設定

背景透過は既存設定を維持しています。
