# 61uehigh/tap

Homebrew formulae by [61uehigh](https://github.com/61uehigh).

Homebrew loads formulae from taps outside its own only after you trust them, so trust this tap once:

```sh
brew tap 61uehigh/tap
brew trust 61uehigh/tap
```

Then install by name:

```sh
brew install uncork
```

| Formula | Description |
|---|---|
| [`uncork`](https://github.com/61uehigh/uncork) | Drag-and-drop .exe launcher for macOS, powered by Wine |

The [Update uncork](.github/workflows/update-uncork.yml) workflow checks every six hours for a new
[uncork release](https://github.com/61uehigh/uncork/releases) and points the formula at it. It uses only this
repository's short-lived `GITHUB_TOKEN`; no deploy key or token is stored.
