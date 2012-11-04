;ListVars
;Pause
SetTitleMatchMode RegEx

;--- GLOBALS ------------------------------------------------------------------

; populate vars: wa_border_top, wa_border_bottom, wa_border_left, wa_border_right
SysGet, wa_border_, MonitorWorkArea

resize_x := 40
resize_y := 30

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
Send ^!{Tab}
Send {Enter}
return

; F1 key closes the active window (who needs a dedicated key for help anyway?)
F1::Send !{F4}

+F1::
MsgBox, S-F1 works.
return

;--- WIN + SINGLE LETTER SHORTCUTS --------------------------------------------

#+a::
IfWinExist, TimSaTo-Tracker$
WinActivate
return

#+b::
IfWinExist, Opera$
WinActivate
return

#+c::
WinGetClass, class, A
MsgBox, Window class is "%class%".
return

; defines the Explorers window group and activates the two LRU of them
#+e::
if WinExist("ahk_group Explorers") {
    GroupActivate, Explorers
}
else {
    GroupAdd, Explorers, ahk_class CabinetWClass
    GroupActivate, Explorers
}
GroupActivate, Explorers
return

#+f::
IfWinExist, FreeMind
WinActivate
return

#+i::
IfWinExist, Eclipse$
WinActivate
return

#+k::
IfWinExist, Microsoft Outlook$
WinActivate
return

#+m::
if WinExist("ahk_class SunAwtFrame")
WinActivate
return

; recalculates the work area dimensions, e.g. after switching from laptop screen to docking station; see GLOBALS.
#+r::
SysGet, wa_border_, MonitorWorkArea
MsgBox, Work area dimensions recalculated.
return

#+t::
IfWinExist, ^terminal$
WinActivate
return

; maximizes current window vertically
#+v::
WinMove, A,,, wa_border_top,, wa_border_bottom
return

#+w::
IfWinExist, Winamp
WinActivate
return

#+y::WinMinimize, A

;--- DECREASE WINDOW SIZE IN ONE DIRECTION -------------------------------------------

#^left::
WinGetPos, xpos,, width,, A
target_width := width - resize_x
WinMove, A,,,, %target_width%
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
WinGetPos,, ypos,, height, A
target_height := height - resize_y
target_ypos := ypos + resize_y
WinMove, A,,, %target_ypos%,, %target_height%
return

;--- INCREASE WINDOW SIZE IN ONE DIRECTION -------------------------------------------

#+left::
WinGetPos, xpos,, width,, A
target_width := width + resize_x
target_xpos := xpos - resize_x
if (target_xpos < wa_border_left) {
    target_xpos := wa_border_left
    target_width := width + (xpos - wa_border_left)
}
WinMove, A,, %target_xpos%,, %target_width%
return

#+right::
WinGetPos, xpos,, width,, A
target_width := width + resize_x
if (xpos + target_width > wa_border_right) {
    target_width := width + (wa_border_right - (xpos + width))
}
WinMove, A,,,, %target_width%
return

#+up::
WinGetPos,, ypos,, height, A
target_height := height + resize_y
target_ypos := ypos - resize_y
if (target_ypos < wa_border_top) {
    target_ypos := wa_border_top
    target_height := height + (ypos - wa_border_top)
}
WinMove, A,,, %target_ypos%,, %target_height%
return

#+down::
WinGetPos,, ypos,, height, A
target_height := height + resize_y
if (ypos + target_height > wa_border_bottom) {
    target_height := height + (wa_border_bottom - (ypos + height))
}
WinMove, A,,,,, %target_height%
return

;--- MOVE WINDOW TO THE BORDER OF THE SCREEN ----------------------------------

#!left::
WinMove, A,, %wa_border_left%
return

#!right::
WinGetPos,,, width,, A
target_xpos := wa_border_right - width
WinMove, A,, %target_xpos%
return

#!up::
WinMove, A,,, %wa_border_top%
return

#!down::
WinGetPos,,,, height, A
target_ypos := wa_border_bottom - height
WinMove, A,,, %target_ypos%
return

;--- MOVE WINDOW INTO A CORNER OF THE SCREEN ----------------------------------

#Numpad1::
WinGetPos,,,, height, A
target_xpos := wa_border_left
target_ypos := wa_border_bottom - height
WinMove, A,, %target_xpos%, %target_ypos%
return

#Numpad3::
WinGetPos,,, width, height, A
target_xpos := wa_border_right - width
target_ypos := wa_border_bottom - height
WinMove, A,, %target_xpos%, %target_ypos%
return

; moves the window to the center of the screen
#Numpad5::
WinGetPos,,, width, height, A
target_xpos := ((wa_border_right - wa_border_left) / 2) - (width / 2)
target_ypos := ((wa_border_bottom - wa_border_top) / 2) - (height / 2)
WinMove, A,, %target_xpos%, %target_ypos%
return

#Numpad7::
target_xpos := wa_border_left
target_ypos := wa_border_top
WinMove, A,, %target_xpos%, %target_ypos%
return

#Numpad9::
WinGetPos,,, width,, A
target_xpos := wa_border_right - width
target_ypos := wa_border_top
WinMove, A,, %target_xpos%, %target_ypos%
return

;------------------------------------------------------------------------------
;--- WINDOW-SPECIFIC HOTKEYS --------------------------------------------------
;------------------------------------------------------------------------------

; Defines hotkeys for browsers:
; * prevent closing of tabs with ctrl-w by accident
; * toggle between the two most recently focused tabs (ctrl-tab)

#IfWinActive, ahk_class OperaWindowClass
^w::MsgBox ctrl-w caught.
NumpadAdd::Send ^{Tab}
F1::Send ^{F4}

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
Numpad1::Send ^{PgUp}
Numpad2::Send ^{PgDn}

;------------------------------------------------------------------------------
