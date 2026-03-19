<p align="center">
  <img width="797" height="212" alt="high-resolution-color-logo" src="https://github.com/user-attachments/assets/dc553ac0-ec23-4d27-8a73-f73de97b8f6e" />
</p>

# Clipdock

Clipdock is a lightweight MacOS service that runs in background and your last 20 clipboard items.


## Demo

Insert gif or link to demo!

## Features

- Lightweight
- Shows last 20 clipboard items
- Avoid to store duplicate items
- Quick access from menubar
- Shows when item copied

## Installation

- Install the `Clipdock-1.0.0-macOS.zip` from the [latest release](https://github.com/rajpatelbot/clipdock/releases/tag/v1.0.0)
- Unzip it and open the folder in Terminal
- Run the installer-

    ```bash
    ./install.sh
    ```

Clipdock will start immediately and launch automatically at every login.
Look for the **Clipdock icon** in your menu bar.

### Uninstall
To uninstall the clipdock open the same folder in Terminal and run -
```bash
./uninstall.sh
```

This will stop the service and remove it from your system completely.


## Tech Stack

- Golang
- `github.com/getlantern/systray` for ui
## Limitations

- macOS only  
- No persistent storage  
- Text-only support  

## Authors

- [@rajpatelbot](https://www.github.com/rajpatelbot)
