// This is a Carbon framework which is used to register a global level hotkey.
#include <Carbon/Carbon.h>

/* This function has been declared using extern keyword which says to compiler that it will later use in go file so it doesn't
throw any type of error.
*/
extern void onHotkeyPressed();

/* These are private variables used to store references of key, so we can unregister the hotkey when app quit. */
static EventHandlerRef gHotkeyHandlerRef;
static EventHotKeyRef gHotkeyRef;

/* hotkeyHandler is a callback function that Carbon calls everytime when our registered combined key (eg. cmd+shift+.) will be
pressed by user.

@params:
- nextHandler — reference to the next event handler in the event chain.
- event — the event object containing information about the triggered hotkey. (eg. modifiers, keycode etc.)
- userData — custom pointer we passed during registration (we passed NULL)
*/
static OSStatus hotkeyHandler(EventHandlerCallRef nextHandler, EventRef event, void *userData)
{
    onHotkeyPressed();
    return noErr;
}

/* This function is responsible to take shortcut (eg. cmd+shift+.) and register it as global hotkey for with the help of Carbon.
Also the go file will also use this function.
*/
void registerHotkey()
{
    // Created a variable called `hotkeyId` with type of `EventHotKeyID` and assigning `signature` and `id` for my unique shortcut (eg. cmd+shift+.).
    EventHotKeyID hotkeyId;
    hotkeyId.signature = 'htk1';
    hotkeyId.id = 1;

    // Created a `eventType` variable with type of `EventTypeSpec` as it need to specify about the event which are going to pass.
    // So `eventClass` is a keyboard event (shortcut key) and `eventKind` means event has triggered, means button has pressed.
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;

    // This function is attaching the `hotkeyHandler` callback function with the application's event target so the carbon knows, which function it needs to call.
    InstallEventHandler(
        GetApplicationEventTarget(),
        hotkeyHandler,
        1,
        &eventType,
        NULL,
        &gHotkeyHandlerRef);

    // This function tells MacOS to watch for the key (cmd+Shift+.) combo globally.
    RegisterEventHotKey(
        kVK_ANSI_Slash,                  // / key defined in karbon
        controlKey | optionKey | cmdKey, // control+option+command
        hotkeyId,                        // map this combo with defined id
        GetApplicationEventTarget(),
        0,
        &gHotkeyRef);
}
