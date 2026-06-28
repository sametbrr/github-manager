#!/usr/bin/env bash
# add-release-workflow.sh <repo-dir> [--type skill|npm|nuget|python|generic] [--force]
# Repo'ya proje-tipine uygun .github/workflows/release.yml koyar. Sadece yoksa (veya --force).
# Commit/push YAPMAZ (CLAUDE.md #8).
set -uo pipefail

dir="${1:?kullanım: add-release-workflow.sh <repo-dir> [--type T] [--force]}"
shift || true
type=""
force=""
while [ $# -gt 0 ]; do
  case "$1" in
    --type)  type="${2:-}"; shift 2;;
    --force) force=1; shift;;
    *) echo "bilinmeyen argüman: $1"; exit 2;;
  esac
done

[ -d "$dir" ] || { echo "✘ dizin yok: $dir"; exit 1; }
tpldir="$(cd "$(dirname "$0")/../assets/templates" && pwd)"

# proje tipi tespiti (readme-standard sırası: package.json > csproj > pyproject > SKILL.md > VERSION)
if [ -z "$type" ]; then
  if   [ -f "$dir/package.json" ]; then type=npm
  elif find "$dir" -maxdepth 3 -name '*.csproj' | grep -q .; then type=nuget
  elif [ -f "$dir/pyproject.toml" ]; then type=python
  elif [ -f "$dir/SKILL.md" ]; then type=skill
  elif [ -f "$dir/VERSION" ]; then type=generic
  else echo "✘ proje tipi tespit edilemedi: $dir (--type ile belirt ya da VERSION dosyası ekle)"; exit 1
  fi
fi

src="$tpldir/release-$type.yml"
[ -f "$src" ] || { echo "✘ geçersiz tip '$type' (skill|npm|nuget|python|generic)"; exit 2; }
dest="$dir/.github/workflows/release.yml"

if [ -f "$dest" ] && [ -z "$force" ]; then
  echo "release.yml zaten var, atlandı ($type): $dest  (üzerine yazmak için --force)"
  exit 0
fi

mkdir -p "$(dirname "$dest")"
cp "$src" "$dest"
echo "release.yml yazıldı ($type): $dest"
