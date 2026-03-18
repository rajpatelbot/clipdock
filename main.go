package main

import (
	_ "embed"

	"github.com/getlantern/systray"
)

//go:embed clipboard.png
var icon []byte

var clipboardItems = []Clipboard{}
var lastContent string

func main() {
	go watcher()
	initializeClipboardItem()
	systray.Run(onReady, onExit)
}

func onReady() {
	systray.SetIcon(icon)
	systray.SetTitle(" ")
	systray.SetTooltip("Clipdock - Clipboard Manager")
	updateMenu()
}

func onExit() {}
