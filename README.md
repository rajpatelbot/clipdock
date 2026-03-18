# 📋 Clipdock – Clipboard Manager (macOS)

Clipdock is a lightweight clipboard manager built in Go that runs in your macOS system tray. It continuously monitors your clipboard and stores a history of copied items, allowing you to quickly reuse them anytime.

---

## 🚀 About the Project

Clipdock is designed to solve a simple problem: **macOS does not provide clipboard history by default in MacOS Sequoia**.

This app runs silently in the background and:
- Tracks your clipboard in real-time  
- Stores last 20 copied items  
- Lets you quickly copy them again from the menu bar  

---

## ✨ Features

- 📌 **Clipboard History Tracking**  
  Automatically stores last 20 copied text items.

- ⚡ **Real-time Monitoring**  
  Checks clipboard every 500ms.

- 🧠 **Duplicate Prevention**  
  Avoids storing the same content repeatedly.

- 📋 **Quick Access from Menu Bar**  
  Click the icon to view history.

- 🔁 **One-click Re-copy**  
  Click any item to copy it again.

- 🕒 **Timestamp Support**  
  Shows when the item was copied.

- 🧹 **Clean UI**  
  Trimmed preview with date display.

---

## 🛠️ Built With

- **Go (Golang)** – Core logic  
- **github.com/getlantern/systray** – System tray UI  
- **macOS Clipboard Commands**
  - `pbcopy`
  - `pbpaste`

---

## 📂 Project Structure

```
.
├── main.go
├── watcher.go
├── menu.go
├── clipboard.go
├── utils.go
├── clipboard.png
```

---

## ▶️ Getting Started

### Prerequisites

- macOS
- Go (1.18+)

### Run

```bash
go run .
```

### Build

```bash
go build -o clipdock
./clipdock
```

---

## 💡 Why is it Lightweight?

- Uses **goroutines** (very cheap threads)  
- Minimal UI via **systray** (no heavy frameworks)  
- No database (in-memory only)  
- Uses native macOS tools (`pbcopy`, `pbpaste`)  
- Low CPU usage (checks every 500ms)  
- Small binary size  

---

## ⚠️ Limitations

- macOS only  
- No persistent storage  
- Text-only support  
