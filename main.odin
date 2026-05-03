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
        {16*0.5, 9*0.5},
        0,
        120,
    }

    paddle = Paddle{{16/2, 8, PADDLE_DEFAULT_LENGTH, 0.3}, PADDLE_DEFAULT_COLOR, 0, false, 0}

    ball = Ball{{16/2, 9/2}, 2, {0, 1}}

    bricks = make([dynamic]Brick)
    defer delete(bricks)
    append(&bricks, Brick{.RECTANGLE, {4, 6}, {4, 1}})
    append(&bricks, Brick{.CIRCLE, {10, 6}, {1, 0}})
    append(&bricks, Brick{.RECTANGLE45, {1, 6}, {1.5, 0.3}})
    append(&bricks, Brick{.RECTANGLE45, {15, 5}, {2, 2}})

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
        // draw border
        rl.DrawRectangleRec({0, -0.06, 16, 0.06}, {100, 100, 100, 255})
        rl.DrawRectangleRec({0, 9, 16, 0.06}, {100, 100, 100, 255})
        rl.DrawRectangleRec({-0.06, 0, 0.06, 9}, {100, 100, 100, 255})
        rl.DrawRectangleRec({16, 0, 0.06, 9}, {100, 100, 100, 255})

        DrawBall(&ball)

        DrawPaddle(&paddle)

        for &brick in bricks {
            DrawBrick(&brick)
        }
    }
    rl.EndMode2D()

    when ODIN_DEBUG do DebugDraw()

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



DebugDraw :: proc() {
    rl.DrawFPS(10, 10)
}
