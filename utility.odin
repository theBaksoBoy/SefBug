package main

import rl "vendor:raylib"


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



Rotated45Vector2 :: proc (vec: rl.Vector2) -> rl.Vector2 {
    return rl.Vector2{0.970710678 * (vec.x - vec.y), 0.970710678 * (vec.x + vec.y)}
}
