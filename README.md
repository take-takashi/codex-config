# codex-config

Codex CLI用のconfig管理リポジトリ。

## 初回セットアップ

```sh
git clone https://github.com/take-takashi/codex-config.git ~/github/codex-config
ln -s ~/github/codex-config ~/.codex
cd ~/.codex
./scripts/apply-config.sh
```

## 管理方針

- `~/.codex` はこのリポジトリへのsymlinkにする
- `config.toml` はGit管理しない
- `config.managed.toml` と `scripts/apply-config.sh` で共通設定のmanaged blockだけ更新する
- `skills/`, `rules/`, `agents/` はGit管理する
- Codexが生成するログ、履歴、認証情報、state、cacheはGit管理しない
