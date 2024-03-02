#!/usr/bin/env bash

TEMPDIR="/tmp/user/$(id -u "$USER")"
cd "$TEMPDIR" || exit 1

[[ -d "$TEMPDIR/vscode-copy/og" ]] && rm -rf "$TEMPDIR/vscode-copy/og" > /dev/null 2>&1
mkdir -p "$TEMPDIR/vscode-copy/og"

[[ -d  "$TEMPDIR/vscode-copy/og/code" ]] && rm -rf "$TEMPDIR/vscode-copy/og/code" > /dev/null 2>&1
sudo cp -rfv /usr/share/code "$TEMPDIR/vscode-copy/og/code"
sudo chown -R tim:tim "$TEMPDIR/vscode-copy/og/code"

[[ -d  "$TEMPDIR/vscode-copy/og/code-insiders" ]] && rm -rf "$TEMPDIR/vscode-copy/og/code-insiders" > /dev/null 2>&1
sudo cp -rfv /usr/share/code-insiders "$TEMPDIR/vscode-copy/og/code-insiders"
sudo chown -R tim:tim "$TEMPDIR/vscode-copy/og/code-insiders"

[[ -d  "$TEMPDIR/vscode-copy/og/vscode" ]] && rm -rf "$TEMPDIR/vscode-copy/og/vscode" > /dev/null 2>&1
cp -rfv $HOME/.vscode "$TEMPDIR/vscode-copy/og/vscode"

[[ -d  "$TEMPDIR/vscode-copy/og/vscode-insiders" ]] && rm -rf "$TEMPDIR/vscode-copy/og/vscode-insiders" > /dev/null 2>&1
cp -rfv $HOME/.vscode-insiders "$TEMPDIR/vscode-copy/og/vscode-insiders"

sudo chown -R tim:tim "$TEMPDIR/vscode-copy"

cp -rf "$TEMPDIR/vscode-copy/og/code" "$TEMPDIR/vscode-copy/code"
cp -rf "$TEMPDIR/vscode-copy/og/code-insiders" "$TEMPDIR/vscode-copy/code-insiders"
cp -rf "$TEMPDIR/vscode-copy/og/vscode" "$TEMPDIR/vscode-copy/vscode"
cp -rf "$TEMPDIR/vscode-copy/og/vscode-insiders" "$TEMPDIR/vscode-copy/vscode-insiders"

chown -R 440 "$TEMPDIR/vscode-copy/og"

mkdir -p "$TEMPDIR/vscode-copy/nb"
mkdir -p "$TEMPDIR/vscode-copy/script"
mv -fv "$TEMPDIR/vscode-copy" "$HOME/.cache//vscode-copy"
#!/usr/bin/env bash

TEMPDIR="/tmp/user/$(id -u "$USER")"
cd "$TEMPDIR" || exit 1

[[ -d "$TEMPDIR/vscode-copy/og" ]] && rm -rf "$TEMPDIR/vscode-copy/og" > /dev/null 2>&1
mkdir -p "$TEMPDIR/vscode-copy/og"

[[ -d  "$TEMPDIR/vscode-copy/og/code" ]] && rm -rf "$TEMPDIR/vscode-copy/og/code" > /dev/null 2>&1
cp -rf /usr/share/code "$TEMPDIR/vscode-copy/og/code"

[[ -d  "$TEMPDIR/vscode-copy/og/code-insiders" ]] && rm -rf "$TEMPDIR/vscode-copy/og/code-insiders" > /dev/null 2>&1
cp -rf /usr/share/code-insiders "$TEMPDIR/vscode-copy/og/code-insiders"

[[ -d  "$TEMPDIR/vscode-copy/og/vscode" ]] && rm -rf "$TEMPDIR/vscode-copy/og/vscode" > /dev/null 2>&1
cp -rf $HOME/.vscode "$TEMPDIR/vscode-copy/og/vscode"

[[ -d  "$TEMPDIR/vscode-copy/og/vscode-insiders" ]] && rm -rf "$TEMPDIR/vscode-copy/og/vscode-insiders" > /dev/null 2>&1
cp -rf $HOME/.vscode-insiders "$TEMPDIR/vscode-copy/og/vscode-insiders"

sudo chown -R tim:tim "$TEMPDIR/vscode-copy"

cp -rf "$TEMPDIR/vscode-copy/og/code" "$TEMPDIR/vscode-copy/code"
cp -rf "$TEMPDIR/vscode-copy/og/code-insiders" "$TEMPDIR/vscode-copy/code-insiders"
cp -rf "$TEMPDIR/vscode-copy/og/vscode" "$TEMPDIR/vscode-copy/vscode"
cp -rf "$TEMPDIR/vscode-copy/og/vscode-insiders" "$TEMPDIR/vscode-copy/vscode-insiders"

# chown -R 440 "$TEMPDIR/vscode-copy/og"

mkdir -p "$TEMPDIR/vscode-copy/nb"
mkdir -p "$TEMPDIR/vscode-copy/script"
mv -fv "$TEMPDIR/vscode-copy" "$HOME/.cache/vscode-copy"

