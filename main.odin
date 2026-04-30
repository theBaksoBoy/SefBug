package main

import rl "vendor:raylib"
import "core:math"



paddle: Paddle
ball: Ball
bricks: [dynamic]Brick



main :: proc() {

    rl.InitWindow(1920, 1080, "SefBug")
    rl.ToggleFullscreen()
    rl.SetExitKey(.KEY_NULL)
    rl.SetTargetFPS(60)
    rl.DisableCursor()

    paddle = Paddle{{1920/2, 1000, PADDLE_DEFAULT_LENGTH, 30}, PADDLE_DEFAULT_COLOR, 0, false, 0}

    ball = Ball{{1920/2, 1080/2}, 300, {0, 1}}

    bricks = make([dynamic]Brick)
    defer delete(bricks)
    append(&bricks, Brick{.RECTANGLE, {300, 300}, {300, 100}})
    append(&bricks, Brick{.CIRCLE, {700, 500}, {100, 0}})
    append(&bricks, Brick{.RECTANGLE45, {1000, 600}, {150, 30}})

    for !rl.WindowShouldClose() {

        Update()
        Draw()
    }


    rl.CloseWindow()
}



Update :: proc() {

    // run special debug logic when testing the game
    when ODIN_DEBUG {
        DebugUpdate()
    }

    // move paddle
    paddle.vel += rl.GetMouseDelta().x * 0.3
    paddle.vel *= 0.7
    paddle.rec.x += paddle.vel


    // update size of paddle when transitioning from powerup being activated or disabled
    // update powerup_factor of paddle
    if (!paddle.long_powerup_active && paddle.powerup_factor != 0) || (paddle.long_powerup_active && paddle.powerup_factor != 1) {

        if paddle.long_powerup_active {
            paddle.powerup_factor += rl.GetFrameTime() * PADDLE_POWERUP_TRANSITION_SPEED
        } else {
            paddle.powerup_factor -= rl.GetFrameTime() * PADDLE_POWERUP_TRANSITION_SPEED
        }

        if paddle.powerup_factor > 1 do paddle.powerup_factor = 1
        if paddle.powerup_factor < 0 do paddle.powerup_factor = 0
    }


    // update paddle parameters according to powerup_factor

    // width
    old_width := paddle.rec.width
    paddle.rec.width = Lerp(PADDLE_DEFAULT_LENGTH, PADDLE_LONG_LENGTH, paddle.powerup_factor)
    // move paddle so that scaling appears to be done from center
    paddle.rec.x -= (paddle.rec.width - old_width) * 0.5

    // color
    paddle.color = LerpColor(PADDLE_DEFAULT_COLOR, PADDLE_LONG_COLOR, paddle.powerup_factor)



    // make sure paddle doesn't go offscreen
    if paddle.rec.x < 0 {
        paddle.rec.x = 0
        paddle.vel = 0
    } else if paddle.rec.x + paddle.rec.width > 1920 {
        paddle.rec.x = 1920 - paddle.rec.width
        paddle.vel = 0
    }

    UpdateBall(&ball)
}



Draw :: proc() {

    rl.BeginDrawing()
    rl.ClearBackground({20, 15, 15, 255})

    DrawBall(&ball)

    DrawPaddle(&paddle)

    for &brick in bricks {
        DrawBrick(&brick)
    }

    rl.EndDrawing()
}



DebugUpdate :: proc() {
    if rl.IsKeyPressed(.SPACE) {
        paddle.long_powerup_active = !paddle.long_powerup_active
    }
}
