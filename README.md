# 61uehigh/tap

Homebrew formulae by [61uehigh](https://github.com/61uehigh).

```sh
brew install 61uehigh/tap/uncork
```

Or add the tap once, then use the short name:

```sh
brew tap 61uehigh/tap
brew install uncork
```

| Formula | Description |
|---|---|
| [`uncork`](https://github.com/61uehigh/uncork) | Drag-and-drop .exe launcher for macOS, powered by Wine |
| [`mothership`](https://github.com/61uehigh/mothership) | Personal workspace for your work tools and Claude, Codex, and GPT agents |

The [Update uncork](.github/workflows/update-uncork.yml) workflow checks every six hours for a new
[uncork release](https://github.com/61uehigh/uncork/releases) and points the formula at it. It uses only this
repository's short-lived `GITHUB_TOKEN`; no deploy key or token is stored.
