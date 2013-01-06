;ListVars
;Pause
SetTitleMatchMode RegEx

;--- GLOBALS ------------------------------------------------------------------

resize_x := 40
resize_y := 30

/*
This function determines the monitor on which the currently active
window resides and populates some monitor-specific variables.
Must be called from the key binding definition before working with
one of these global variables:
    wa_border_top, wa_border_bottom, wa_border_left, wa_border_right
*/
CalcWABorders() {
    global
    WinGetPos, xpos, ypos,,, A
    SysGet, cnt, MonitorCount
    Loop, %cnt% {
        SysGet, border_, Monitor, %A_Index%
        if (xpos >= border_left && xpos <= border_right && ypos >= border_top && ypos <= border_bottom) {
            mon_number := A_Index
            break
        }
    }
    SysGet, wa_border_, MonitorWorkArea, %mon_number%
}

;------------------------------------------------------------------------------
;--- HOTSTRINGS ---------------------------------------------------------------
;------------------------------------------------------------------------------
;--- q starts all hotstrings, use it followed by zero to force a literal character
:*?r:q0::q
;--- single characters
:*?r:q1::^ `
:*?r:q7::\
:*?r:q#::'
:*?r:qp::|
:*?r:qq::@
;--- pairs of braces
; to get a literal curly brace it must be wrapped into a pair of curly braces
:*?b0:qj::{bs 2}{{}{}}{left 1}
:*?b0:qk::{bs 2}`[`]{left 1}
;--- free keys: abcdefghilmnorstuvwxyz

;------------------------------------------------------------------------------
;--- HOTKEYS ------------------------------------------------------------------
;------------------------------------------------------------------------------

; Make numpad decimal separator a dot instead of comma (my locale default)
NumpadDot::Send .

; CAPSLOCK toggles between the two most recently focused windows
CapsLock::
Send !{Tab}
;AERO: Send ^!{Tab}
;AERO: Send {Enter}
return

; F1 key closes the active window (who needs a dedicated key for help anyway?)
F1::Send !{F4}

+F1::
MsgBox, S-F1 works.
return

;------------------------------------------------------------------------------
;--- SHIFT + WIN + SINGLE LETTER SHORTCUTS ------------------------------------

#+a::
IfWinExist, TimSaTo-Tracker$
WinActivate
return

#+c::
WinGetClass, class, A
MsgBox, Window class is "%class%".
return

#+f::
IfWinExist, FreeMind
WinActivate
return

#+i::
IfWinExist, Eclipse$
WinActivate
return

; focus on muCommander that does not contain its name in title, so ignore all other java windows that uses the same window class
#+m::
IfWinExist, ahk_class SunAwtFrame,, TimSaTo-Tracker|FreeMind|MagicDraw|SQuirreL|soapUI
WinActivate
return

#+q::
IfWinExist, SQuirreL
WinActivate
return

; maximizes current window vertically
#+v::
CalcWABorders()
WinMove, A,,, wa_border_top,, wa_border_bottom
return

#+y::WinMinimize, A

;------------------------------------------------------------------------------
;--- CHANGE WINDOW SIZE AT THE LEFT / LOWER BORDER ----------------------------

#^left::
CalcWABorders()
WinGetPos, xpos,, width,, A
target_width := width + resize_x
target_xpos := xpos - resize_x
if (target_xpos < wa_border_left) {
    target_xpos := wa_border_left
    target_width := width + (xpos - wa_border_left)
}
WinMove, A,, %target_xpos%,, %target_width%
return

#^right::
WinGetPos, xpos,, width,, A
target_width := width - resize_x
target_xpos := xpos + resize_x
WinMove, A,, %target_xpos%,, %target_width%
return

#^up::
WinGetPos,, ypos,, height, A
target_height := height - resize_y
WinMove, A,,,,, %target_height%
return

#^down::
CalcWABorders()
WinGetPos,, ypos,, height, A
target_height := height + resize_y
if (ypos + target_height > wa_border_bottom) {
    target_height := height + (wa_border_bottom - (ypos + height))
}
WinMove, A,,,,, %target_height%
return

;------------------------------------------------------------------------------
;--- MOVE WINDOW TO THE BORDER OF THE SCREEN ----------------------------------

#!left::
CalcWABorders()
WinMove, A,, %wa_border_left%
return

#!right::
CalcWABorders()
WinGetPos,,, width,, A
target_xpos := wa_border_right - width
WinMove, A,, %target_xpos%
return

#!up::
CalcWABorders()
WinMove, A,,, %wa_border_top%
return

#!down::
CalcWABorders()
WinGetPos,,,, height, A
target_ypos := wa_border_bottom - height
WinMove, A,,, %target_ypos%
return

;------------------------------------------------------------------------------
;--- MOVE WINDOW INTO A CORNER OF THE SCREEN ----------------------------------

#Numpad1::
CalcWABorders()
WinGetPos,,,, height, A
target_xpos := wa_border_left
target_ypos := wa_border_bottom - height
WinMove, A,, %target_xpos%, %target_ypos%
return

#Numpad3::
CalcWABorders()
WinGetPos,,, width, height, A
target_xpos := wa_border_right - width
target_ypos := wa_border_bottom - height
WinMove, A,, %target_xpos%, %target_ypos%
return

#Numpad7::
CalcWABorders()
target_xpos := wa_border_left
target_ypos := wa_border_top
WinMove, A,, %target_xpos%, %target_ypos%
return

#Numpad9::
CalcWABorders()
WinGetPos,,, width,, A
target_xpos := wa_border_right - width
target_ypos := wa_border_top
WinMove, A,, %target_xpos%, %target_ypos%
return

;------------------------------------------------------------------------------
;--- WINDOW-SPECIFIC HOTKEYS --------------------------------------------------
;------------------------------------------------------------------------------

; Defines hotkeys for certain windows:
; * prevent closing of tabs with ctrl-w by accident
; * toggle between the two most recently focused tabs (ctrl-tab)

#IfWinActive, ahk_class OperaWindowClass
^w::MsgBox ctrl-w caught.
F1::Send ^{F4}
^PgUp::Send +^{F6}
^PgDn::Send ^{F6}

#IfWinActive, ahk_class MozillaWindowClass
^w::MsgBox ctrl-w caught.
NumpadAdd::Send ^{Tab}
F1::Send ^{F4}
F4::
Send c
Sleep 250
Send inbox${Enter}
return
F12::
Send c
Sleep 250
Send inbox${Up}{Enter}
return

#IfWinActive, Eclipse$
^w::MsgBox ctrl-w caught.
F1::Send ^{F4}

#IfWinActive, ^SQuirreL
F1::Send +^{F4}
;------------------------------------------------------------------------------
