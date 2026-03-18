// menu.go
package main

import (
	"fmt"
	"strings"

	"github.com/getlantern/systray"
)

var menuItems []*systray.MenuItem

// This function is responsible to show the history list.
func updateMenu() {
	// We have to hide all previously rendered list.
	for _, item := range menuItems {
		item.Hide()
	}

	// Render in reverse so newest item appears at top
	for i := len(clipboardItems) - 1; i >= 0; i-- {
		item := clipboardItems[i]

		// prepare index number to show in the list.
		index := len(clipboardItems) - i

		// trim the spaces from item.
		value := strings.TrimSpace(item.Value)

		if len(value) > 30 {
			value = value[:30] + "..."
		}

		date := item.Date.Format("02 Jan, 03:04 PM")
		m := systray.AddMenuItem(fmt.Sprintf("%d)  %s", index, value), "")
		menuItems = append(menuItems, m)

		dateLabel := systray.AddMenuItem("    "+date, "")
		dateLabel.Disable() // grayed out, not clickable
		menuItems = append(menuItems, dateLabel)

		handleMenuClick(item, m)
	}

	systray.AddSeparator()
}

// This function is responsible to again copy the clicked item from ui list.
func handleMenuClick(item Clipboard, m *systray.MenuItem) {
	go func(val string, menuItem *systray.MenuItem) {
		for {
			<-menuItem.ClickedCh
			copyToClipboard(val)
		}
	}(item.Value, m)
}
