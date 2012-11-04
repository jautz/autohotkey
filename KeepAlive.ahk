;--- SETTINGS -----------------------------------------------------------------
distance_x_px := 50
interval_secs := 720 ; 12 min

;--- MAIN LOOP ----------------------------------------------------------------
; Moves the mouse pointer left and right by distance_x_px in regular intervals
;
movement_x := distance_x_px
suppress_dialog := 0
interval_millis := interval_secs * 1000

Loop {
    movement_x := -1 * movement_x
    MouseMove, %movement_x%, 0, , R

    if (suppress_dialog = 1) {
        Sleep, %interval_millis%
        continue
    }
    else {
        MsgBox, 3, KeepAlive active, Would you like to quit KeepAlive?`nChoose Cancel to keep running without this dialog., %interval_secs%
        IfMsgBox, Yes
            break
        IfMsgBox, Cancel
            suppress_dialog := 1
    }
}
