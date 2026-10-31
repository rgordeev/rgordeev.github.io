#!/bin/sh
# Apply repository-local defaults. Safe to run again after cloning.
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(git -C "$script_dir/.." rev-parse --show-toplevel)
cd "$repo_root"

# .gitattributes defines the shared line-ending policy.
git config --local core.autocrlf false
git config --local core.eol lf
git config --local core.safecrlf true
git config --local core.quotePath false

# Pull only when the update can preserve the existing linear history.
git config --local fetch.prune true
git config --local pull.ff only
git config --local push.default simple
git config --local push.autoSetupRemote true

# Readable changes and conflicts; review reused conflict resolutions.
git config --local diff.algorithm histogram
git config --local diff.renames true
git config --local merge.conflictStyle zdiff3
git config --local rerere.enabled true
git config --local rerere.autoupdate false
git config --local commit.verbose true

# Verify objects received from remotes and certificates used for HTTPS.
git config --local transfer.fsckObjects true
git config --local fetch.fsckObjects true
git config --local http.sslVerify true

# On macOS, reset inherited helpers and use the system Keychain.
# This replaces an inherited plaintext "store" helper for this repo only.
if [ "$(uname -s)" = Darwin ] &&
    [ -x "$(git --exec-path)/git-credential-osxkeychain" ]; then
    git config --local --replace-all credential.helper ''
    git config --local --add credential.helper osxkeychain
fi

printf '%s\n' 'Repository-local Git settings applied.'
