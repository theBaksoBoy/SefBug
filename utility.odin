package main

import rl "vendor:raylib"
import "core:math"


Lerp :: proc(a, b, t: f32) -> f32 {
    return a + (b - a) * t;
}



LerpColor :: proc (a, b: rl.Color, t: f32) -> rl.Color {
    return rl.Color{
        byte(Lerp(f32(a[0]), f32(b[0]), t)),
        byte(Lerp(f32(a[1]), f32(b[1]), t)),
        byte(Lerp(f32(a[2]), f32(b[2]), t)),
        byte(Lerp(f32(a[3]), f32(b[3]), t)),
    }
}



LerpVector2 :: proc(a, b: rl.Vector2, t: f32) -> rl.Vector2 {
    return a + (b - a) * t;
}



// to make decay work the same no matter the FPS
// decay has a useful range of approximately 1 to 25 (slow to fast)
// use like this: value_to_decay = ExpDecay(value_to_decay, decay_to, 16)
ExpDecay :: proc (a, b, decay: f32) -> f32 {
    return b + (a - b) * math.exp_f32(-decay * rl.GetFrameTime())
}



RotatedVector2 :: proc (vec: rl.Vector2, angle: f32) -> rl.Vector2 {

    sin_angle := math.sin_f32(angle)
    cos_angle := math.cos_f32(angle)

    return rl.Vector2{vec.x * cos_angle - vec.y * sin_angle, vec.x * sin_angle + vec.y * cos_angle}
}



Rotated45Vector2 :: proc (vec: rl.Vector2) -> rl.Vector2 {
    return rl.Vector2{0.707106781 * (vec.x - vec.y), 0.707106781 * (vec.x + vec.y)}
}



V2DotProduct :: proc(a, b: rl.Vector2) -> f32 {
    return a.x*b.x + a.y*b.y
}



V2Magnitude :: proc(a: rl.Vector2) -> f32 {
    return math.sqrt(a.x*a.x + a.y*a.y)
}



V2Normalized :: proc(a: rl.Vector2) -> rl.Vector2 {
    return a / V2Magnitude(a)
}
