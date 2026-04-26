package main

import rl "vendor:raylib"



main :: proc() {

    rl.InitWindow(1280, 720, "SefBug")
    rl.SetTargetFPS(60)
    rl.DisableCursor()

    for !rl.WindowShouldClose() {

        rl.BeginDrawing()
        rl.ClearBackground({20, 15, 15, 255})
        rl.DrawRectangleV({1280/2, 720/2}, rl.GetMouseDelta(), rl.RED)
        rl.EndDrawing()
    }


    rl.CloseWindow()
}
