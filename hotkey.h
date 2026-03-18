// This is a header file with function defination, which the go program will use to listen the keyboard.

// This is a guard to prevent the header file to import more than 1 time in single file.
#pragma once
#ifndef HOTKEY_H
#define HOTKEY_H

// registerHotkey() is a function that will setup a system level shortcut key, (cmd+shift+.) in this case.
void registerHotkey();
void RunApplicationEventLoop();

#endif
