package main

import "time"

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

// This function is responsible to generate a clipboardItems array when it is empty when this service restart or initialize.
func initializeClipboardItem() {
	lastContent, _ = pasteFromClipboard()

	// Prepared new object with required dataType for current copied item.
	newClipboardItem := Clipboard{
		Value: lastContent,
		Date:  time.Now(),
	}

	if len(clipboardItems) == 0 {
		clipboardItems = append(clipboardItems, newClipboardItem)
	}
}
