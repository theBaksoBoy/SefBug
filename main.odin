package main

import rl "vendor:raylib"

main :: proc() {

    rl.InitWindow(1280, 720, "SefBug")
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {

        rl.BeginDrawing()
        rl.ClearBackground({20, 15, 15, 255})
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
