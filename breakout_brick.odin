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
        return point.x > brick.pos.x && point.x < brick.pos.x + brick.size.x && point.y > brick.pos.y && point.y < brick.pos.y + brick.size.y

    case.CIRCLE:
        return V2Magnitude(point - brick.pos) < brick.size.x

    case.RECTANGLE45:
        return false
    }

    return false // needed or it will cry
}

GetBrickCollisionNormal :: proc(brick: ^Brick, moving_body_center: rl.Vector2) -> rl.Vector2 {
    switch brick.brick_type {

    case .RECTANGLE:
        top_left := brick.pos
        top_right := brick.pos + {brick.size.x, 0}
        bottom_left := brick.pos + {0, brick.size.y}
        bottom_right := brick.pos + brick.size

        // find the slope and offset to make it go thought the points
        k: f32 = (top_right.y - bottom_left.y) / (top_right.x - bottom_left.x)
        c_positive: f32 = bottom_left.y - k * bottom_left.x
        c_negative: f32 = top_left.y - (-k) * top_left.x

        above_positive_line: bool = moving_body_center.y > k * moving_body_center.x + c_positive
        above_negative_line: bool = moving_body_center.y > (-k) * moving_body_center.x + c_negative

        if above_positive_line && above_negative_line { // top side
            return {0, 1}
        } else if !above_positive_line && !above_negative_line { // bottom side
            return {0, -1}
        } else if above_positive_line && !above_negative_line { // left side
            return {-1, 0}
        } else { // right side
            return {1, 0}
        }

    case .CIRCLE:
        return V2Normalized(moving_body_center - brick.pos)

    case .RECTANGLE45:
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
