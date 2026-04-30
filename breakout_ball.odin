package main

import rl "vendor:raylib"
import "core:math"



BALL_RADIUS : f32 : 20
BALL_LINE_WIDTH : f32 : 5
BALL_COLOR :: rl.Color{0, 255, 123, 255}



Ball :: struct {
    pos: rl.Vector2,
    vel: f32,
    angle: f32, // in radians
}



UpdateBall :: proc(ball: ^Ball) {

    quarter_step := rl.Vector2{ball.vel * math.cos_f32(ball.angle), ball.vel * math.sin_f32(ball.angle)} * rl.GetFrameTime() * 0.25

    // do movement and collision detection in quarter-steps
    for i in 0..<4 {
        ball.pos += quarter_step
    }
}



DrawBall :: proc(ball: ^Ball) {
    rl.DrawRing(ball.pos, BALL_RADIUS - BALL_LINE_WIDTH, BALL_RADIUS, 0, 360, 64, BALL_COLOR)
}



BounceAlongNormal :: proc(normal: rl.Vector2) {

}
