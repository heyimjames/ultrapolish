#!/usr/bin/env bash
# Install the ultrapolish skills into the AI tool of your choice.
#
# Usage:
#   ./install.sh <tool> [install|uninstall] [--global]
#
# Examples:
#   ./install.sh claude-code          # prints the marketplace / npx commands
#   ./install.sh cursor               # copy .mdc rules into ./.cursor/rules/
#   ./install.sh cursor --global      # ...into ~/.cursor/rules/ instead
#   ./install.sh codex                # append to ./AGENTS.md (or create it)
#   ./install.sh codex --global       # ...append to ~/.codex/AGENTS.md
#   ./install.sh zed uninstall        # remove the rules again

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX="ultrapolish-"

TOOL="${1:-}"
shift || true

ACTION="install"
GLOBAL=false
for arg in "$@"; do
    case "$arg" in
        uninstall|install) ACTION="$arg" ;;
        --global) GLOBAL=true ;;
    esac
done

usage() {
    cat <<EOF
Usage: ./install.sh <tool> [install|uninstall] [--global]

Tools:
  claude-code   Prints the marketplace and npx commands (nothing is copied)
  cursor        Copy .mdc into .cursor/rules/         (project; --global for ~/.cursor/rules/)
  codex         Append to AGENTS.md                   (project; --global for ~/.codex/AGENTS.md)
  windsurf      Copy .windsurfrules                   (project)
  aider         Copy CONVENTIONS.md                   (project)
  continue      Copy into .continue/rules/            (project; --global for ~/.continue/rules/)
  zed           Copy into .rules/                     (project)

Examples:
  ./install.sh cursor --global
  ./install.sh codex
  ./install.sh zed uninstall
EOF
    exit 1
}

[[ -z "$TOOL" ]] && usage

count() { /bin/ls "$1"/${PREFIX}*."$2" 2>/dev/null | wc -l | tr -d ' '; }

if [[ ! -d "$REPO_DIR/dist" && "$TOOL" != "claude-code" ]]; then
    echo "Building dist/ ..."
    "$REPO_DIR/build.sh" all
fi

case "$TOOL" in
    claude-code)
        cat <<EOF
Claude Code: pick one.

  1. Plugin marketplace (namespaced as ultrapolish:ultrapolish-ios / ultrapolish:ultrapolish-web)

       /plugin marketplace add heyimjames/ultrapolish
       /plugin install ultrapolish@ultrapolish

  2. skills CLI (installs as /ultrapolish-ios and /ultrapolish-web)

       npx skills add heyimjames/ultrapolish -a claude-code -g

  3. Local clone, symlinked (edits are live)

       ln -s "$REPO_DIR/skills/ultrapolish-ios" ~/.claude/skills/ultrapolish-ios
       ln -s "$REPO_DIR/skills/ultrapolish-web" ~/.claude/skills/ultrapolish-web

Uninstall: /plugin uninstall ultrapolish@ultrapolish, or remove the symlinks.
EOF
        ;;

    cursor)
        if [[ "$GLOBAL" == "true" ]]; then TARGET="$HOME/.cursor/rules"; else TARGET="$PWD/.cursor/rules"; fi
        mkdir -p "$TARGET"
        if [[ "$ACTION" == "install" ]]; then
            cp "$REPO_DIR"/dist/cursor/.cursor/rules/*.mdc "$TARGET/"
            echo "Copied $(count "$TARGET" mdc) rules into $TARGET"
            for f in "$TARGET"/${PREFIX}*.mdc; do echo "  $(basename "$f")"; done
            echo "Cursor attaches them automatically based on file globs."
        else
            rm -f "$TARGET"/${PREFIX}*.mdc
            echo "Removed ultrapolish rules from $TARGET"
        fi
        ;;

    codex)
        if [[ "$GLOBAL" == "true" ]]; then
            mkdir -p "$HOME/.codex"; TARGET="$HOME/.codex/AGENTS.md"
        else
            TARGET="$PWD/AGENTS.md"
        fi
        MARKER_BEGIN="<!-- BEGIN ultrapolish -->"
        MARKER_END="<!-- END ultrapolish -->"
        strip_block() {
            python3 - "$TARGET" "$MARKER_BEGIN" "$MARKER_END" <<'PY'
import re, sys
p, b, e = sys.argv[1:4]
s = open(p).read()
s = re.sub(r'\n*' + re.escape(b) + r'.*?' + re.escape(e) + r'\n?', '', s, flags=re.DOTALL)
open(p, 'w').write(s)
PY
        }
        if [[ "$ACTION" == "install" ]]; then
            [[ -f "$TARGET" ]] && grep -q "$MARKER_BEGIN" "$TARGET" && strip_block
            {
                [[ -f "$TARGET" ]] && echo ""
                echo "$MARKER_BEGIN"
                cat "$REPO_DIR/dist/codex/AGENTS.md"
                echo "$MARKER_END"
            } >> "$TARGET"
            echo "Appended ultrapolish to $TARGET"
        else
            if [[ -f "$TARGET" ]] && grep -q "$MARKER_BEGIN" "$TARGET"; then
                strip_block; echo "Removed ultrapolish from $TARGET"
            else
                echo "(no ultrapolish block found in $TARGET)"
            fi
        fi
        ;;

    windsurf)
        TARGET="$PWD/.windsurfrules"
        if [[ "$ACTION" == "install" ]]; then
            cp "$REPO_DIR/dist/windsurf/.windsurfrules" "$TARGET"; echo "Copied .windsurfrules to $TARGET"
        else
            rm -f "$TARGET"; echo "Removed $TARGET"
        fi
        ;;

    aider)
        TARGET="$PWD/CONVENTIONS.md"
        if [[ "$ACTION" == "install" ]]; then
            cp "$REPO_DIR/dist/aider/CONVENTIONS.md" "$TARGET"
            echo "Copied CONVENTIONS.md to $TARGET"
            echo "In .aider.conf.yml set:  read: CONVENTIONS.md"
        else
            rm -f "$TARGET"; echo "Removed $TARGET"
        fi
        ;;

    continue)
        if [[ "$GLOBAL" == "true" ]]; then TARGET="$HOME/.continue/rules"; else TARGET="$PWD/.continue/rules"; fi
        mkdir -p "$TARGET"
        if [[ "$ACTION" == "install" ]]; then
            cp "$REPO_DIR"/dist/continue/.continue/rules/*.md "$TARGET/"
            echo "Copied $(count "$TARGET" md) rules into $TARGET"
        else
            rm -f "$TARGET"/${PREFIX}*.md; echo "Removed ultrapolish rules from $TARGET"
        fi
        ;;

    zed)
        TARGET="$PWD/.rules"
        mkdir -p "$TARGET"
        if [[ "$ACTION" == "install" ]]; then
            cp "$REPO_DIR"/dist/zed/.rules/*.md "$TARGET/"
            echo "Copied $(count "$TARGET" md) rules into $TARGET"
        else
            rm -f "$TARGET"/${PREFIX}*.md; echo "Removed ultrapolish rules from $TARGET"
        fi
        ;;

    *)
        echo "Unknown tool: $TOOL"; echo; usage ;;
esac
