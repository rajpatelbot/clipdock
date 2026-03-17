package main

import "os/exec"

func pasteFromClipboard() (content string, err error) {
	cmd := exec.Command("pbpaste")
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

func main() {
	go watcher()
	startHotkey()
}
