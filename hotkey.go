package main

/*
#cgo LDFLAGS: -framework Carbon
#cgo CFLAGS: -Wno-implicit-function-declaration
#include "hotkey.h"
*/
import "C"

import (
	"fmt"
)

//export onHotkeyPressed
func onHotkeyPressed() {
	fmt.Println("Hotkey pressed")
}

func startHotkey() {
	C.registerHotkey()
	C.RunApplicationEventLoop()
}
