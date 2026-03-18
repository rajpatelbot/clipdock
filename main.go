package main

import (
	"github.com/getlantern/systray"
)

var clipboardItems = []Clipboard{}
var lastContent string

func main() {
	go watcher()
	initializeClipboardItem()
	systray.Run(onReady, onExit)
}

func onReady() {
	systray.SetTitle("Clipdock")
	systray.SetTooltip("Clipboard Manager")
	updateMenu()
}

func onExit() {}
