package main

import (
	"os/exec"
	"time"

	"github.com/getlantern/systray"
)

var clipboardItems = []Clipboard{}
var lastContent string

// This function is responsible to read the current pasted item from clipboard.
func pasteFromClipboard() (content string, err error) {
	cmd := exec.Command("pbpaste")
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

func copyToClipboard(text string) {
	cmd := exec.Command("pbcopy")
	in, _ := cmd.StdinPipe()

	go func() {
		defer in.Close()
		in.Write([]byte(text))
	}()

	cmd.Run()
}

// This function is responsible to generate the history of clipboard items.
// It will contains total 20 items only, rest will be deleted automatically.
func addToHistory(item string) (items []Clipboard) {
	// Prepared new object with required dataType for current copied item.
	newClipboardItem := Clipboard{
		Value: item,
		Date:  time.Now(),
	}

	// Delete the 1st items from array as we are considering to delete the oldest clipboard item.
	if len(clipboardItems) >= 20 {
		clipboardItems = clipboardItems[1:]
	}

	clipboardItems = append(clipboardItems, newClipboardItem)

	updateMenu()

	return clipboardItems
}

func main() {
	go watcher()
	// startHotkey()
	lastContent, _ = pasteFromClipboard()

	// Prepared new object with required dataType for current copied item.
	newClipboardItem := Clipboard{
		Value: lastContent,
		Date:  time.Now(),
	}

	if len(clipboardItems) == 0 {
		clipboardItems = append(clipboardItems, newClipboardItem)
	}

	systray.Run(onReady, onExit)
}

func onReady() {
	systray.SetTitle("Clipdock")
	systray.SetTooltip("Clipboard Manager")

	updateMenu()
}

func onExit() {}
