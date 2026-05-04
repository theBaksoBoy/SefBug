package main

import rl "vendor:raylib"
import "core:math/rand"



BALL_RADIUS : f32 : 0.2
BALL_LINE_WIDTH : f32 : 0.06
BALL_COLOR :: rl.Color{0, 255, 123, 255}



Ball :: struct {
    pos: rl.Vector2,
    vel: f32,
    dir: rl.Vector2,
}



UpdateBall :: proc(ball: ^Ball) {

    // do movement and collision detection in quarter-steps
    for i in 0..<4 {
        ball.pos += ball.vel * ball.dir * rl.GetFrameTime() * 0.25

        ball_collision_points: [8]rl.Vector2 = {
            ball.pos + {BALL_RADIUS, 0},
            ball.pos + {-BALL_RADIUS, 0},
            ball.pos + {0, BALL_RADIUS},
            ball.pos + {0, -BALL_RADIUS},
            ball.pos + {BALL_RADIUS * 0.707106781, BALL_RADIUS * 0.707106781},
            ball.pos + {-BALL_RADIUS * 0.707106781, BALL_RADIUS * 0.707106781},
            ball.pos + {BALL_RADIUS * 0.707106781, -BALL_RADIUS * 0.707106781},
            ball.pos + {-BALL_RADIUS * 0.707106781, -BALL_RADIUS * 0.707106781},
        }

        outer: for &collision_point in ball_collision_points {

            // check for collision against the paddle
            if collision_point.x > paddle.rec.x && collision_point.x < paddle.rec.x + paddle.rec.width && collision_point.y > paddle.rec.y && collision_point.y < paddle.rec.y + paddle.rec.height && ball.dir.y > 0 {
                BounceBallAlongNormal(ball, {0, -1})
                break
            }

            // check for collision against bricks
            for &brick, i in bricks {

                if IsCollidingWithBrick(&brick, collision_point) {
                    BounceBallAlongNormal(ball, GetBrickCollisionNormal(&brick, ball.pos))
                    append(&brick_break_particles_instances, CreateBrickBreakParticles(&brick))
                    unordered_remove(&bricks, i)
                    break outer
                }
            }
        }

        // check for collision against left, right, and top of screen
        if ball.pos.x - BALL_RADIUS < 0 && ball.dir.x < 0 do BounceBallAlongNormal(ball, {1, 0})
        else if ball.pos.x + BALL_RADIUS > 16 && ball.dir.x > 0 do BounceBallAlongNormal(ball, {-1, 0})
        if ball.pos.y - BALL_RADIUS < 0 && ball.dir.y < 0 do BounceBallAlongNormal(ball, {0, 1})


    }
}



DrawBall :: proc(ball: ^Ball) {
    rl.DrawRing(ball.pos, BALL_RADIUS - BALL_LINE_WIDTH, BALL_RADIUS, 0, 360, 64, BALL_COLOR)
}



BounceBallAlongNormal :: proc(ball: ^Ball, normal: rl.Vector2) {

    // bounce
    ball.dir = ball.dir - 2 * V2DotProduct(ball.dir, normal) * normal

    // randomly rotate it a small amount
    ball.dir = RotatedVector2(ball.dir, rand.float32() * 0.2 - 0.2/2) // ~7 degree spread in each direction

    // move camera target in response to the bounce
    breakout_camera_velocity += normal * 0.03
}
