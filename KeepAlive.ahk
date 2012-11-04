
FileDelete, KeepAlive.on

show_splash() {
    SplashTextOn,,, "KeepAlive active, moving the mouse pointer in regular intervals."
    Sleep 5000
    SplashTextOff
    return
}

Loop {
    if FileExist("KeepAlive.on") {
        show_splash()
        MouseMove, 50, 0, , R
        show_splash()
        MouseMove, -50, 0, , R
    }
    else {
        Sleep 5000
    }

}
