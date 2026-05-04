package main

import rl "vendor:raylib"



PADDLE_DEFAULT_LENGTH : f32 : 2
PADDLE_DEFAULT_COLOR :: rl.Color{255, 130, 0, 255}
PADDLE_LONG_LENGTH : f32 : 4
PADDLE_LONG_COLOR :: rl.Color{255, 0, 0, 255}
PADDLE_POWERUP_TRANSITION_SPEED : f32 : 2
PADDLE_LINE_WIDTH : f32 : 0.06



Paddle :: struct {
    rec: rl.Rectangle,
    color: rl.Color,
    vel: f32, // x velocity
    long_powerup_active: bool,
    powerup_factor: f32, // used for animating transition to and from the powerup. 0-1
}



UpdatePaddle :: proc(paddle: ^Paddle) {

    // move paddle
    paddle.vel += rl.GetMouseDelta().x * 0.1
    paddle.rec.x += paddle.vel * rl.GetFrameTime() * 0.5
    paddle.vel = ExpDecay(paddle.vel, 0, 16)
    paddle.rec.x += paddle.vel * rl.GetFrameTime() * 0.5

    // move camera in response to paddle movement
    breakout_camera_velocity.x += paddle.vel * rl.GetFrameTime() * 0.01


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
    } else if paddle.rec.x + paddle.rec.width > 16 {
        paddle.rec.x = 16 - paddle.rec.width
        paddle.vel = 0
    }
}



DrawPaddle :: proc(paddle: ^Paddle) {

    rl.DrawRectangleRec({paddle.rec.x, paddle.rec.y, PADDLE_LINE_WIDTH, paddle.rec.height}, paddle.color)
    rl.DrawRectangleRec({paddle.rec.x + paddle.rec.width - PADDLE_LINE_WIDTH, paddle.rec.y, PADDLE_LINE_WIDTH, paddle.rec.height}, paddle.color)
    rl.DrawRectangleRec({paddle.rec.x, paddle.rec.y, paddle.rec.width, PADDLE_LINE_WIDTH}, paddle.color)
    rl.DrawRectangleRec({paddle.rec.x, paddle.rec.y + paddle.rec.height - PADDLE_LINE_WIDTH, paddle.rec.width, PADDLE_LINE_WIDTH}, paddle.color)
}
