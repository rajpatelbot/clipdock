package main

import "os/exec"

// This function is responsible to read the current pasted item from clipboard.
func pasteFromClipboard() (content string, err error) {
	cmd := exec.Command("pbpaste")
	out, err := cmd.Output()

	if err != nil {
		return "", err
	}

	return string(out), nil
}

// This function is responsible to write the data in clipboard.
func copyToClipboard(text string) {
	cmd := exec.Command("pbcopy")
	in, _ := cmd.StdinPipe()

	go func() {
		defer in.Close()
		in.Write([]byte(text))
	}()

	cmd.Run()
}
