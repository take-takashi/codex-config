---
name: go-tdd-implementation
description: Go言語の実装・修正・リファクタリングをt-wada式TDDで進める。Goコード、CLI、ライブラリ、Web API、既存バグ修正、境界値を含むユニットテスト追加、設計を伴う実装変更で使う。実装前に日本語の自然言語コメントでPython-likeな擬似コードを書き、そのコメントを満たす形で正しい設計に基づくGoコードだけを書く必要があるときに使う。
---

# Go TDD Implementation

## Core Rule

t-wada式TDDで、小さく Red -> Green -> Refactor を回す。ad-hocな変更、テストを後付けするだけの実装、根拠のないフォールバック、場当たり的な分岐を避ける。

実装前に、対象の関数・メソッド・処理ブロックへ日本語の自然言語コメントでPython-likeな擬似コードを書く。そのコメントを設計の約束として扱い、実装はコメントの手順を満たすように書く。

## Workflow

1. 要求を振る舞いとして整理する。
   - 入力、出力、副作用、エラー、境界値を明確にする。
   - 既存コードがある場合は、周辺の設計・命名・パッケージ境界を先に読む。

2. Red: 失敗するユニットテストを先に書く。
   - 正常系、異常系、境界値を含める。
   - テストケースには「何を確認しているか」を日本語コメントで残す。
   - table driven test を優先する。ただし単発の方が読みやすい場合は無理に表にしない。

3. Green: 最小限の実装を書く。
   - 実装前に日本語コメントでPython-likeな擬似コードを書く。
   - 擬似コードの下に、それを満たすGoコードを書く。
   - テストを通すためだけのハードコードや、将来の仕様を推測した分岐を入れない。

4. Refactor: 設計を整える。
   - 重複、責務、名前、エラーの扱い、パッケージ境界を見直す。
   - リファクタ後も同じテストを通す。
   - コメントが実装とズレたら、コメントか実装のどちらかを正す。

5. 検証する。
   - `go test ./...` を実行する。
   - 変更範囲に応じて `go fmt ./...`, `go vet ./...`, `go mod tidy` も実行する。
   - mise管理プロジェクトでは、存在する場合は `mise run test`, `mise run fmt`, `mise run vet`, `mise run tidy`, `mise run check` を優先する。

## Test Requirements

ユニットテストでは境界値を必ず検討する。数値なら最小値、最大値、ゼロ、負数、閾値の直前・直後を考える。文字列なら空文字、空白、マルチバイト文字、長い文字列を考える。コレクションならnil、空、1件、複数件を考える。時間や外部入力が絡む場合は固定可能な境界を作る。

テストには日本語コメントを書く。

```go
func TestNormalizeName(t *testing.T) {
	tests := []struct {
		name string
		in   string
		want string
	}{
		// 前後の空白を取り除き、小文字へ正規化することを確認する。
		{name: "trim and lower", in: "  Taro  ", want: "taro"},
		// 空文字は空文字のまま扱うことを確認する。
		{name: "empty", in: "", want: ""},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := NormalizeName(tt.in)
			if got != tt.want {
				t.Fatalf("NormalizeName(%q) = %q, want %q", tt.in, got, tt.want)
			}
		})
	}
}
```

## Pseudocode Comments

実装前コメントは、Go構文ではなく日本語の自然言語を基本にし、Python-likeに上から読める手順として書く。

```go
func NormalizeName(s string) string {
	// 入力文字列の前後の空白を取り除く
	// 残った文字列を小文字に変換する
	// 変換した文字列を返す
	trimmed := strings.TrimSpace(s)
	return strings.ToLower(trimmed)
}
```

コメントは「なぜその分岐があるか」「どの順序で処理するか」が伝わる粒度にする。自明な代入やGo構文の説明を書かない。

## Design Discipline

正しい設計に基づく正しいコードだけを書く。

- 既存の設計、パッケージ境界、命名、エラー処理に合わせる。
- 標準ライブラリで十分な場合は標準ライブラリを優先する。
- 仕様不明な挙動を勝手に補完しない。必要ならユーザーに確認するか、明示的な前提として扱う。
- バグを隠すフォールバック、握りつぶしたエラー、説明できない分岐を入れない。
- テストのために本番コードを歪めない。必要なら依存をインターフェースや引数で注入する。
- CLIではロジックを `main` に閉じ込めず、テスト可能な関数やパッケージへ分ける。

## Completion Criteria

完了時は、追加・変更した振る舞い、書いたテスト、実行した検証コマンドを簡潔に報告する。検証できなかった場合は理由を明記する。
