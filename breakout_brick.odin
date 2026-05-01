package main

import rl "vendor:raylib"
import "core:math"



BRICK_LINE_WIDTH : f32 : 5
BRICK_COLOR :: rl.Color{200, 0, 75, 255}




Brick_Type :: enum {
    RECTANGLE,
    CIRCLE,
    RECTANGLE45,
}



Brick :: struct {
    brick_type: Brick_Type,
    pos: rl.Vector2,
    size: rl.Vector2, // note! for rectangle types this is with width and height, but for the circle only the first index is used which is the radius
}



IsCollidingWithBrick :: proc(brick: ^Brick, point: rl.Vector2) -> bool {
    switch brick.brick_type {

    case .RECTANGLE:
        return false
    case.CIRCLE:
        return V2Magnitude(point - brick.pos) < brick.size.x
    case.RECTANGLE45:
        return false
    }

    return false // needed or it will cry
}

GetBrickCollisionNormal :: proc(brick: ^Brick, point: rl.Vector2) -> rl.Vector2 {
    switch brick.brick_type {

    case .RECTANGLE:
        return {0, 0}
    case.CIRCLE:
        return V2Normalized(point - brick.pos)
    case.RECTANGLE45:
        return {0, 0}
    }

    return {0, 0} // needed or it will cry
}


DrawBrick :: proc(brick: ^Brick) {
    switch brick.brick_type {

    case .RECTANGLE:
        rl.DrawRectangleRec({brick.pos.x, brick.pos.y, BRICK_LINE_WIDTH, brick.size.y}, BRICK_COLOR)
        rl.DrawRectangleRec({brick.pos.x + brick.size.x - BRICK_LINE_WIDTH, brick.pos.y, BRICK_LINE_WIDTH, brick.size.y}, BRICK_COLOR)
        rl.DrawRectangleRec({brick.pos.x, brick.pos.y, brick.size.x, BRICK_LINE_WIDTH}, BRICK_COLOR)
        rl.DrawRectangleRec({brick.pos.x, brick.pos.y + brick.size.y - BRICK_LINE_WIDTH, brick.size.x, BRICK_LINE_WIDTH}, BRICK_COLOR)

    case .CIRCLE:
        rl.DrawRing({brick.pos.x, brick.pos.y}, brick.size.x - BRICK_LINE_WIDTH, brick.size.x, 0, 360, 64, BRICK_COLOR)

    case .RECTANGLE45:
        rl.DrawLineEx( // top
            brick.pos + Rotated45Vector2({BRICK_LINE_WIDTH * 0.25, BRICK_LINE_WIDTH * 0.5}),
            brick.pos + Rotated45Vector2({brick.size.x - BRICK_LINE_WIDTH * 0.75, BRICK_LINE_WIDTH * 0.5}),
            BRICK_LINE_WIDTH,
            BRICK_COLOR,
        )
        rl.DrawLineEx( // bottom
            brick.pos + Rotated45Vector2({BRICK_LINE_WIDTH * 0.25, brick.size.y - BRICK_LINE_WIDTH}),
            brick.pos + Rotated45Vector2({brick.size.x - BRICK_LINE_WIDTH * 0.75, brick.size.y - BRICK_LINE_WIDTH}),
            BRICK_LINE_WIDTH,
            BRICK_COLOR,
        )
        rl.DrawLineEx( // left
            brick.pos + Rotated45Vector2({BRICK_LINE_WIDTH * 0.5, BRICK_LINE_WIDTH * 0.25}),
            brick.pos + Rotated45Vector2({BRICK_LINE_WIDTH * 0.5, brick.size.y - BRICK_LINE_WIDTH * 0.75}),
            BRICK_LINE_WIDTH,
            BRICK_COLOR,
        )
        rl.DrawLineEx( // right
            brick.pos + Rotated45Vector2({brick.size.x - BRICK_LINE_WIDTH, BRICK_LINE_WIDTH * 0.25}),
            brick.pos + Rotated45Vector2({brick.size.x - BRICK_LINE_WIDTH, brick.size.y - BRICK_LINE_WIDTH * 0.75}),
            BRICK_LINE_WIDTH,
            BRICK_COLOR,
        )
    }
}
