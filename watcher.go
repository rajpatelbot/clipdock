package main

import (
	"fmt"
	"strings"
	"time"
)

func watcher() {
	initial, _ := pasteFromClipboard()
	lastContent = strings.TrimRight(initial, "\n")

	// This loop with continuously check the new content of clipboard.
	for {
		content, err := pasteFromClipboard()
		// If any unexpected error occured while reading clipboard, sleep for sometime and then retry.
		if err != nil {
			fmt.Printf("Error while reading clipboard %v\n", err)
			time.Sleep(500 * time.Millisecond)
			continue
		}

		content = strings.TrimRight(content, "\n")

		// This check will ensure that when we get any new content in clipboard, push it into the clipboard history.
		if content != "" && content != lastContent {
			lastContent = content
			addToHistory(content)
		}

		// Sleep/pause this function for 500 millisecond, it means clipboard is checked 2 times per second.
		// It helps to prevent this function to utilize more memory.
		time.Sleep(500 * time.Millisecond)
	}
}
