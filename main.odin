package main

import rl "vendor:raylib"
import "core:math"



paddle: Paddle
ball: Ball
bricks: [dynamic]Brick
breakout_camera: rl.Camera2D


main :: proc() {

    monitor := rl.GetCurrentMonitor()
    rl.InitWindow(rl.GetMonitorWidth(monitor), rl.GetMonitorHeight(monitor), "SefBug")
    rl.ToggleFullscreen()
    rl.SetExitKey(.KEY_NULL)
    rl.SetTargetFPS(60)
    rl.DisableCursor()

    breakout_camera = rl.Camera2D{
        {f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight()) / 2},
        {1920/2, 1080/2},
        0,
        1,
    }

    paddle = Paddle{{1920/2, 1000, PADDLE_DEFAULT_LENGTH, 30}, PADDLE_DEFAULT_COLOR, 0, false, 0}

    ball = Ball{{1920/2, 1080/2}, 300, {0, 1}}

    bricks = make([dynamic]Brick)
    defer delete(bricks)
    append(&bricks, Brick{.RECTANGLE, {300, 300}, {300, 100}})
    append(&bricks, Brick{.CIRCLE, {700, 500}, {100, 0}})
    append(&bricks, Brick{.RECTANGLE45, {100, 600}, {150, 30}})
    append(&bricks, Brick{.RECTANGLE45, {1500, 500}, {200, 200}})

    for !rl.WindowShouldClose() {

        Update()
        Draw()
    }

    rl.CloseWindow()
}



Update :: proc() {

    // run special debug logic when testing the game
    when ODIN_DEBUG do DebugUpdate()

    UpdatePaddle(&paddle)
    UpdateBall(&ball)
}



Draw :: proc() {

    rl.BeginDrawing()
    rl.ClearBackground({20, 15, 15, 255})

    // draw everything with the breakout camera's perspective
    // note that the code doesn't need to be in a block, but it is done to make it more clear
    // what is being done using the camera's perspective and not
    rl.BeginMode2D(breakout_camera)
    {
        DrawBall(&ball)

        DrawPaddle(&paddle)

        for &brick in bricks {
            DrawBrick(&brick)
        }
    }
    rl.EndMode2D()

    rl.EndDrawing()
}



DebugUpdate :: proc() {
    if rl.IsKeyPressed(.SPACE) {
        paddle.long_powerup_active = !paddle.long_powerup_active
    }
    if rl.IsKeyDown(.LEFT) {
        ball.dir = RotatedVector2(ball.dir, -0.1)
    }
    if rl.IsKeyDown(.RIGHT) {
        ball.dir = RotatedVector2(ball.dir, 0.1)
    }
}
