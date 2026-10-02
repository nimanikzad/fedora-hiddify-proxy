# Fedora Hiddify Proxy

A small Bash helper for Fedora 44 users who use Hiddify. Turn terminal proxy environment variables on or off with one command.

No sudo, extra packages, or background services required.

## Before you start

- Use a Bash terminal.
- Start Hiddify and connect to your server.
- Check the local HTTP or mixed HTTP/SOCKS proxy port in Hiddify. This helper uses **12334** by default; your configuration may use a different port.

## Install

Download `proxy.sh` from this repository and save it in your Downloads folder. Run:

```bash
mkdir -p ~/.config/hiddify-proxy
cp -i ~/Downloads/proxy.sh ~/.config/hiddify-proxy/proxy.sh
source ~/.config/hiddify-proxy/proxy.sh
proxy
```

`cp -i` asks before overwriting an existing copy. If your download folder has another name, adjust the source path.

To load the helper automatically in new Bash terminals, run once:

```bash
touch ~/.bashrc
if ! grep -Fqx 'source "$HOME/.config/hiddify-proxy/proxy.sh"' ~/.bashrc; then
    printf '\nsource "$HOME/.config/hiddify-proxy/proxy.sh"\n' >> ~/.bashrc
fi
```

If you already have a function named `proxy`, this helper replaces that function in terminals where it is loaded. Review your existing definition before adding automatic loading.

## Use

```bash
proxy            # Open the menu
proxy on         # Enable the proxy on port 12334
proxy on 8080    # Enable the proxy on a different HTTP/mixed port
proxy status     # Display current proxy variables
proxy off        # Clear proxy variables in this terminal
```

To change the default port for the current terminal:

```bash
export HIDDIFY_PROXY_PORT=8080
proxy on
```

For a persistent default, add that export line to `~/.bashrc` using your text editor.

## How it works

The helper sets `http_proxy`, `https_proxy`, `all_proxy` and their uppercase equivalents to `http://127.0.0.1:PORT`. It excludes localhost through `no_proxy` and `NO_PROXY`.

The `http://` URL describes the local proxy connection, including for HTTPS destinations. Use Hiddify's HTTP or mixed listener, not a SOCKS-only port.

Load the file with `source` so the function can change the current shell's environment. Running `bash proxy.sh` only prints loading instructions.

Changes affect the current terminal and programs started from it that honor these variables. They do not change system-wide settings, other terminals, or already-running applications. Some programs ignore proxy environment variables. `proxy off` clears these variables; it does not restore their previous values or disable Hiddify's TUN mode.

## Quick check

```bash
proxy on
proxy status
curl --max-time 15 --head https://example.com
```

The status command reports environment settings, not whether Hiddify is connected. If curl cannot connect, check Hiddify's connection and local listener port.

## Remove

Remove the helper's `source` line from `~/.bashrc`. In any terminal where it is already loaded, run:

```bash
proxy off
unset -f proxy
```

You can then remove `~/.config/hiddify-proxy/proxy.sh` with your file manager.

## Compatibility and validation

Designed for Bash on Fedora 44. Bash syntax, port validation, and environment-variable behavior were checked in an isolated Bash session. A live Fedora 44/Hiddify connection has not been tested as part of this release.

## License

MIT. See [LICENSE](LICENSE). This is an independent helper and is not affiliated with Hiddify or Fedora.
