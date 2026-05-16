package main

import rl "vendor:raylib"
import "core:math"
import "core:math/rand"



PARTICLES_PER_LENGTH_UNIT :: 20

ExplosionParticles :: struct {
    count: int,
    positions: [dynamic]rl.Vector2,
    velocities: [dynamic]rl.Vector2,
    alpha: f32,
}



DrawExplosionParticles :: proc(explosion_particles: ^ExplosionParticles) {
    color := BRICK_COLOR
    color[3] = u8(explosion_particles.alpha)

    for i in 0..<explosion_particles.count {
        rl.DrawRectangleV(explosion_particles.positions[i] - BRICK_LINE_WIDTH * 0.5, {BRICK_LINE_WIDTH, BRICK_LINE_WIDTH}, color)
    }
}



UpdateExplosionParticles :: proc(explosion_particles: ^ExplosionParticles) {

    for i in 0..<explosion_particles.count {
        explosion_particles.positions[i] += explosion_particles.velocities[i] * rl.GetFrameTime()
    }

    explosion_particles.alpha -= rl.GetFrameTime() * 400

    if explosion_particles.alpha < 0 do explosion_particles.alpha = 0
}



DeleteExplosionParticles :: proc(explosion_particles: ^ExplosionParticles) {
    delete(explosion_particles.positions)
    delete(explosion_particles.velocities)
}



CreateBrickBreakParticles :: proc(brick: ^Brick) -> ExplosionParticles {

    // calculate how many particles should be spawned, based on the size of the perimiter
    count: int
    switch brick.brick_type {
    case .RECTANGLE, .RECTANGLE45:
        count = int((brick.size.x + brick.size.y) * 2 * PARTICLES_PER_LENGTH_UNIT)
    case .CIRCLE:
        count = int(brick.size.x * 2 * math.PI * PARTICLES_PER_LENGTH_UNIT)
    }

    brick_break_particles := ExplosionParticles{
        count,
        make([dynamic]rl.Vector2, count),
        make([dynamic]rl.Vector2, count),
        255,
    }

    switch brick.brick_type {
    case .RECTANGLE, .RECTANGLE45:

        line_pos: f32

        corner0: rl.Vector2
        corner1: rl.Vector2
        corner2: rl.Vector2
        corner3: rl.Vector2
        if brick.brick_type == .RECTANGLE {
            corner0 = brick.pos + {BRICK_LINE_WIDTH * 0.5, BRICK_LINE_WIDTH * 0.5}
            corner1 = brick.pos + {brick.size.x, 0} + {-BRICK_LINE_WIDTH * 0.5, BRICK_LINE_WIDTH * 0.5}
            corner2 = brick.pos + brick.size + {-BRICK_LINE_WIDTH * 0.5, -BRICK_LINE_WIDTH * 0.5}
            corner3 = brick.pos + {0, brick.size.y} + {BRICK_LINE_WIDTH * 0.5, -BRICK_LINE_WIDTH * 0.5}
        } else {
            corner0 = brick.pos + Rotated45Vector2({BRICK_LINE_WIDTH * 0.5, BRICK_LINE_WIDTH * 0.5})
            corner1 = brick.pos + Rotated45Vector2({brick.size.x, 0} + {-BRICK_LINE_WIDTH * 0.5, BRICK_LINE_WIDTH * 0.5})
            corner2 = brick.pos + Rotated45Vector2(brick.size + {-BRICK_LINE_WIDTH * 0.5, -BRICK_LINE_WIDTH * 0.5})
            corner3 = brick.pos + Rotated45Vector2({0, brick.size.y} + {BRICK_LINE_WIDTH * 0.5, -BRICK_LINE_WIDTH * 0.5})
        }

        for i in 0..<count {
            line_pos += (brick.size.x + brick.size.y) * 2 / f32(count)


            if line_pos < brick.size.x { // line_pos on first line of rectangle
                t := line_pos / brick.size.x
                brick_break_particles.positions[i] = LerpVector2(corner0, corner1, t)
            } else if line_pos < brick.size.x + brick.size.y { // line_pos on second line of rectangle
                t := (line_pos - brick.size.x) / brick.size.y
                brick_break_particles.positions[i] = LerpVector2(corner1, corner2, t)
            } else if line_pos < brick.size.x + brick.size.y + brick.size.x { // line_pos on third line of rectangle
                t := (line_pos - brick.size.x - brick.size.y) / brick.size.x
                brick_break_particles.positions[i] = LerpVector2(corner2, corner3, t)
            } else { // line_pos on last line of rectangle
                t := (line_pos - brick.size.x - brick.size.y - brick.size.x) / brick.size.y
                brick_break_particles.positions[i] = LerpVector2(corner3, corner0, t)
            }
            brick_break_particles.velocities[i] = {rand.float32() * 2 - 1, rand.float32() * 2 - 1}
        }


    case .CIRCLE:
        for i in 0..<count {
            brick_break_particles.positions[i] = brick.pos + RotatedVector2({brick.size.x - BRICK_LINE_WIDTH * 0.5, 0}, math.TAU / f32(count) * f32(i))
            brick_break_particles.velocities[i] = {rand.float32() * 2 - 1, rand.float32() * 2 - 1}
        }
    }

    return brick_break_particles
}



