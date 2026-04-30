package main

import rl "vendor:raylib"



PADDLE_DEFAULT_LENGTH : f32 : 200
PADDLE_DEFAULT_COLOR :: rl.Color{255, 130, 0, 255}
PADDLE_LONG_LENGTH : f32 : 400
PADDLE_LONG_COLOR :: rl.Color{255, 0, 0, 255}
PADDLE_POWERUP_TRANSITION_SPEED : f32 : 2
PADDLE_LINE_WIDTH : f32 : 5



Paddle :: struct {
    rec: rl.Rectangle,
    color: rl.Color,
    vel: f32, // x velocity
    long_powerup_active: bool,
    powerup_factor: f32, // used for animating transition to and from the powerup. 0-1
}



DrawPaddle :: proc(paddle: ^Paddle) {

    rl.DrawRectangleRec({paddle.rec.x, paddle.rec.y, PADDLE_LINE_WIDTH, paddle.rec.height}, paddle.color)
    rl.DrawRectangleRec({paddle.rec.x + paddle.rec.width - PADDLE_LINE_WIDTH, paddle.rec.y, PADDLE_LINE_WIDTH, paddle.rec.height}, paddle.color)
    rl.DrawRectangleRec({paddle.rec.x, paddle.rec.y, paddle.rec.width, PADDLE_LINE_WIDTH}, paddle.color)
    rl.DrawRectangleRec({paddle.rec.x, paddle.rec.y + paddle.rec.height - PADDLE_LINE_WIDTH, paddle.rec.width, PADDLE_LINE_WIDTH}, paddle.color)
}
