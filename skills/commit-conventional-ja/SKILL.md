---
name: commit-conventional-ja
description: >-
  Conventional Commits 1.0.0形式で日本語コミットを作成する。ユーザーが「コミットして」「Conventional Commitでまとめて」「差分を良い感じでコミット」などを依頼したときに使う。件名は type(scope): subject を守り、本文は日本語の「変更内容」「背景」ブロックで記載する。
---

# Commit Conventional JA

以下の手順で実行する。

1. 変更状態を確認する。
   - `git status --short`
   - `git diff --name-only`
   - `git diff`
2. 差分を確認し、Conventional Commits の `type` と必要なら `scope` を決める。
   - 例: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
3. 差分を意味のある単位に分ける。
   - 1コミットは1つの意図に対応させる。
   - ファイル単位ではなく、変更目的やレビューしやすさを基準にまとめる。
   - 依存関係のある変更は、土台、利用側、調整の順に時系列を守ってコミットする。
   - 自分が触っていない変更や用途が異なる変更を同じコミットに混ぜない。
4. 不要な内容が含まれていないか確認する。
   - `.DS_Store`、秘密情報、キャッシュ、PC固有の不要な絶対パスを含めない。
   - 判断できない未追跡ファイルやユーザー変更は勝手に stage しない。
5. 日本語コミットメッセージを作る。
   - 1行目: `<type>(<scope>): <要約>` または `<type>: <要約>`
   - 本文: 次の3ブロックを使う。

```text
変更内容:
- ...
- ...

検証:
- ...

背景:
- ...
```

6. `git add` と `git commit` を実行する。
   - 原則として `git commit -m "件名" -m "本文全体"` を使い、一時ファイルは避ける。
   - 本文は 1 つの `-m` にまとめ、`変更内容:`、`検証:`、`背景:` のブロックをその中で改行して記載する。
   - 複数コミットを作る場合は、各コミットごとに対象差分とメッセージを確認する。
7. コミット結果を確認する。
   - `git show --no-patch --pretty=fuller HEAD`
   - `git show --stat --oneline HEAD`
   - `git status --short`

## Rules

- 日本語で書く。
- Conventional Commits 1.0.0 形式を厳守する。
- 変更ファイルと本文の箇条書きを一致させる。
- 実行した検証コマンドを本文に含める。未実行の場合は理由を書く。
- 破壊的変更がある場合のみ `!` と `BREAKING CHANGE:` を使う。
- ユーザーから type/scope 指定があればそれを優先する。

## Output Style

- 最終報告では以下を簡潔に示す。
  - コミットハッシュ
  - コミット件名
  - 変更ファイル一覧
