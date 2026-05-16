#!/bin/sh
set -eu

repo="$(cd "$(dirname "$0")/.." && pwd)"
config="$repo/config.toml"
managed="$repo/config.managed.toml"
begin="# BEGIN codex-config managed: common"
end="# END codex-config managed: common"

tmp="$repo/.config.toml.tmp.$$"
trap 'rm -f "$tmp"' EXIT

touch "$config"

validate_markers() {
	file="$1"
	label="$2"
	required="$3"

	begin_count="$(grep -Fxc "$begin" "$file" || true)"
	end_count="$(grep -Fxc "$end" "$file" || true)"

	if [ "$begin_count" -ne "$end_count" ] || [ "$begin_count" -gt 1 ]; then
		printf '%s\n' "error: invalid managed markers in $label" >&2
		exit 1
	fi

	if [ "$required" = "required" ] && [ "$begin_count" -ne 1 ]; then
		printf '%s\n' "error: managed markers are missing in $label" >&2
		exit 1
	fi

	if [ "$begin_count" -eq 1 ] && ! awk -v begin="$begin" -v end="$end" '
		$0 == begin { seen_begin = 1 }
		$0 == end {
			if (!seen_begin) exit 1
			seen_end = 1
		}
		END { exit !(seen_begin && seen_end) }
	' "$file"; then
		printf '%s\n' "error: managed markers are out of order in $label" >&2
		exit 1
	fi
}

validate_markers "$managed" "$managed" required
validate_markers "$config" "$config" optional

if grep -Fq "$begin" "$config"; then
	awk -v begin="$begin" -v end="$end" -v managed="$managed" '
		$0 == begin {
			while ((getline line < managed) > 0) print line
			close(managed)
			in_block = 1
			next
		}
		$0 == end { in_block = 0; next }
		!in_block { print }
	' "$config" > "$tmp"
else
	{
		cat "$managed"
		printf '\n'
		awk '
			/^\[/ { keep = ($0 ~ /^\[(projects\.|notice\.|marketplaces\.)/) }
			keep {
				if (!printed_blank) { print ""; printed_blank = 1 }
				print
			}
		' "$config"
	} > "$tmp"
fi

mv "$tmp" "$config"
trap - EXIT
