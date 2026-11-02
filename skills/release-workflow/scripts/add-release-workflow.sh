#!/usr/bin/env bash
# add-release-workflow.sh: install a project-type-aware .github/workflows/release.yml into a repo.
#
# Usage: add-release-workflow.sh <repo-dir> [--type T] [--branch B] [--force] [--detect] [--stdout]
#   --type    plugin|skill|npm|mcp|nuget|python|go|go-npm|goreleaser|generic (default: detected)
#   --branch  release branch (default: the remote default branch, then the current branch, then main)
#   --force   overwrite an existing release.yml
#   --detect  print the detected type, branch and parameters, write nothing
#   --stdout  print the rendered workflow instead of writing it
#
# Writes one file only. Never commits, pushes or calls the GitHub API.
set -euo pipefail

usage() { sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; }

[ $# -ge 1 ] || { usage; exit 2; }
case "$1" in -h|--help) usage; exit 0;; esac
dir="$1"; shift
type=""; branch=""; force=""; detect=""; to_stdout=""
while [ $# -gt 0 ]; do
  case "$1" in
    --type)   type="${2:-}"; shift 2;;
    --branch) branch="${2:-}"; shift 2;;
    --force)  force=1; shift;;
    --detect) detect=1; shift;;
    --stdout) to_stdout=1; shift;;
    -h|--help) usage; exit 0;;
    *) echo "unknown argument: $1" >&2; exit 2;;
  esac
done

[ -d "$dir" ] || { echo "error: no such directory: $dir" >&2; exit 1; }
dir="$(cd "$dir" && pwd)"
tpldir="$(cd "$(dirname "$0")/../assets/templates" && pwd)"

# ---------- helpers ----------
json_get() { # json_get <file> <key>  (top-level string/bool, no jq dependency)
  python3 -I -c 'import json,sys
try: v=json.load(open(sys.argv[1])).get(sys.argv[2],"")
except Exception: v=""
print("true" if v is True else "false" if v is False else (v if isinstance(v,str) else ""))' "$1" "$2"
}
has_dep() { # has_dep <package.json> <name>
  python3 -I -c 'import json,sys
d=json.load(open(sys.argv[1]))
deps={**d.get("dependencies",{}),**d.get("devDependencies",{}),**d.get("peerDependencies",{})}
sys.exit(0 if sys.argv[2] in deps else 1)' "$1" "$2" 2>/dev/null
}
find_csproj() { # first packable, non-test csproj (depth ≤ 3), relative to $dir
  local f rel best=""
  while IFS= read -r f; do
    rel="${f#"$dir"/}"
    case "$rel" in *[Tt]est*|*[Bb]enchmark*|*[Ss]ample*) continue;; esac
    grep -q '<IsPackable>[[:space:]]*false' "$f" && continue
    if grep -qE '<PackageId>|<GeneratePackageOnBuild>[[:space:]]*true' "$f"; then echo "$rel"; return; fi
    [ -z "$best" ] && best="$rel"
  done < <(find "$dir" -maxdepth 3 -name '*.csproj' -not -path '*/bin/*' -not -path '*/obj/*' | sort)
  echo "$best"
}
dotnet_version() { # highest netX.Y target framework → X.Y.x (global.json is not read by setup here)
  local proj="$1" v
  v=$(grep -hoE 'net[0-9]+\.[0-9]+' "$dir/$proj" "$dir/Directory.Build.props" 2>/dev/null \
      | sed 's/^net//' | sort -t. -k1,1n -k2,2n | tail -1 || true)
  [ -n "$v" ] && echo "${v}.x" || echo "8.0.x"
}
go_main() { # path of the main package, relative (./cmd/<x> or .)
  local d
  if [ -d "$dir/cmd" ]; then
    for d in "$dir"/cmd/*/; do
      [ -d "$d" ] || continue
      grep -lqs '^package main' "$d"*.go && { d="${d%/}"; echo "./${d#"$dir"/}"; return; }
    done
  fi
  grep -lqs '^package main' "$dir"/*.go && { echo "."; return; }
  echo ""
}
skill_md() { # SKILL.md for a single-skill repo
  if [ -f "$dir/SKILL.md" ]; then echo "SKILL.md"; return; fi
  local n; n=$(find "$dir/skills" -mindepth 2 -maxdepth 2 -name SKILL.md 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" = 1 ]; then f=$(find "$dir/skills" -mindepth 2 -maxdepth 2 -name SKILL.md); echo "${f#"$dir"/}"; return; fi
  echo ""
}

# ---------- type detection (first match wins) ----------
npm_dir=""; reason=""
if [ -z "$type" ]; then
  pkg="$dir/package.json"
  pkg_public=""
  if [ -f "$pkg" ] && [ "$(json_get "$pkg" private)" != "true" ] && [ -n "$(json_get "$pkg" version)" ]; then pkg_public=1; fi
  if [ -f "$dir/go.mod" ]; then
    if ls "$dir"/.goreleaser.y*ml >/dev/null 2>&1; then type=goreleaser; reason="go.mod + .goreleaser.yaml"
    else
      for d in npm packages/npm; do [ -f "$dir/$d/package.json" ] && { npm_dir="$d"; break; }; done
      if [ -n "$npm_dir" ]; then type=go-npm; reason="go.mod + npm wrapper in $npm_dir/"
      else type=go; reason="go.mod"; fi
    fi
  elif [ -n "$pkg_public" ]; then
    if has_dep "$pkg" "@modelcontextprotocol/sdk" || [ -f "$dir/server.json" ]; then type=mcp; reason="package.json + MCP SDK/server.json"
    else type=npm; reason="publishable package.json"; fi
    [ -f "$dir/.claude-plugin/plugin.json" ] && reason="$reason (also an agent plugin; npm publishing wins, keep plugin.json version in sync)"
  elif [ -f "$dir/.claude-plugin/plugin.json" ]; then type=plugin; reason=".claude-plugin/plugin.json"
  elif [ -n "$(find "$dir" -maxdepth 3 -name '*.csproj' -not -path '*/bin/*' -not -path '*/obj/*' -print -quit)" ]; then type=nuget; reason="*.csproj"
  elif [ -f "$dir/pyproject.toml" ]; then type=python; reason="pyproject.toml"
  elif [ -n "$(skill_md)" ]; then type=skill; reason="single SKILL.md"
  elif [ -f "$dir/VERSION" ]; then type=generic; reason="VERSION file"
  elif [ -f "$pkg" ]; then type=npm; reason="private package.json (GitHub release only, no publish)"
  else
    echo "error: could not detect the project type in $dir" >&2
    echo "       pass --type, or add a VERSION file for a generic tag-and-release workflow" >&2
    exit 1
  fi
else
  reason="--type"
fi

case "$type" in plugin|skill|npm|mcp|nuget|python|go|go-npm|goreleaser|generic) ;; *)
  echo "error: invalid type '$type' (plugin|skill|npm|mcp|nuget|python|go|go-npm|goreleaser|generic)" >&2; exit 2;;
esac
src="$tpldir/release-$type.yml"
[ -f "$src" ] || { echo "error: template missing: $src" >&2; exit 1; }

# ---------- default branch ----------
if [ -z "$branch" ]; then
  branch=$(git -C "$dir" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##' || true)
  [ -n "$branch" ] || branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
  [ -n "$branch" ] && [ "$branch" != HEAD ] || branch=main
fi

# ---------- type parameters ----------
csproj=""; dotnet=""; gomain=""; bin=""; skillmd=""
case "$type" in
  nuget)
    csproj=$(find_csproj)
    [ -n "$csproj" ] || { echo "error: no packable *.csproj found" >&2; exit 1; }
    dotnet=$(dotnet_version "$csproj");;
  go|go-npm)
    gomain=$(go_main)
    [ -n "$gomain" ] || { echo "error: no main package found (cmd/<name>/ or root *.go)" >&2; exit 1; }
    if [ "$gomain" = "." ]; then bin=$(sed -n 's#^module[[:space:]]*##p' "$dir/go.mod" | head -1); bin="${bin##*/}"
    else bin="${gomain##*/}"; fi
    if [ "$type" = go-npm ] && [ -z "$npm_dir" ]; then
      for d in npm packages/npm; do [ -f "$dir/$d/package.json" ] && { npm_dir="$d"; break; }; done
      [ -n "$npm_dir" ] || { echo "error: go-npm needs an npm wrapper dir (npm/ or packages/npm/)" >&2; exit 1; }
    fi;;
  skill)
    skillmd=$(skill_md)
    [ -n "$skillmd" ] || { echo "error: no single SKILL.md found (multi-skill repos: use --type plugin)" >&2; exit 1; };;
esac

for v in "$branch" "$csproj" "$gomain" "$bin" "$npm_dir" "$skillmd"; do
  case "$v" in *$'\n'*|*$'\r'*) echo "error: value contains a newline: $v" >&2; exit 1;; esac
done
if ! git check-ref-format --branch "$branch" >/dev/null 2>&1; then
  echo "error: invalid branch name: $branch" >&2; exit 1
fi

rel_dest=".github/workflows/release.yml"
dest="$dir/$rel_dest"

report() {
  echo "repo:    $dir"
  echo "type:    $type ($reason)"
  echo "branch:  $branch"
  [ -n "$csproj" ]  && echo "project: $csproj (dotnet $dotnet)"
  [ -n "$gomain" ]  && echo "main:    $gomain (binary: $bin)"
  [ -n "$npm_dir" ] && echo "npm dir: $npm_dir"
  [ -n "$skillmd" ] && echo "skill:   $skillmd"
  if [ -d "$dir/.github/workflows" ]; then
    local others
    others=$(grep -lE 'npm publish|nuget push|pypi-publish|goreleaser|gh release create|action-gh-release' \
      "$dir"/.github/workflows/*.y*ml 2>/dev/null | grep -v "/release.yml$" || true)
    [ -n "$others" ] && echo "warning: other workflows already publish or release: $(echo "$others" | xargs -n1 basename | tr '\n' ' ')"
  fi
  [ -f "$dest" ] && echo "existing: $rel_dest"
  return 0
}

# Placeholders sit inside single-quoted YAML scalars, so a value only needs '' for each ' (YAML)
# and escaping of \ & | for the sed replacement. Newlines are rejected up front.
yq() { printf '%s' "$1" | sed -e "s/'/''/g" -e 's/[\\&|]/\\&/g'; }
render() {
  sed -e "s|__DEFAULT_BRANCH__|$(yq "$branch")|g" \
      -e "s|__CSPROJ__|$(yq "$csproj")|g" \
      -e "s|__DOTNET_VERSION__|$(yq "$dotnet")|g" \
      -e "s|__GO_MAIN__|$(yq "$gomain")|g" \
      -e "s|__BIN__|$(yq "$bin")|g" \
      -e "s|__NPM_DIR__|$(yq "$npm_dir")|g" \
      -e "s|__SKILL_MD__|$(yq "$skillmd")|g" "$src"
}

if [ -n "$detect" ]; then report; exit 0; fi
if [ -n "$to_stdout" ]; then render; exit 0; fi

report
if [ -f "$dest" ] && [ -z "$force" ]; then
  echo "skipped: $rel_dest already exists (use --force to overwrite)"
  exit 0
fi
mkdir -p "$(dirname "$dest")"
render > "$dest"
echo "written: $rel_dest"
