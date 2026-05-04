package main

import rl "vendor:raylib"


BREAKOUT_CAMERA_FOCUS :: rl.Vector2{16*0.5, 9*0.5}

breakout_camera_velocity: rl.Vector2


UpdateBreakoutCamera :: proc(breakout_camera: ^rl.Camera2D) {

    breakout_camera.target += breakout_camera_velocity

    // decay velocity
    breakout_camera_velocity.x = ExpDecay(breakout_camera_velocity.x, 0, 16)
    breakout_camera_velocity.y = ExpDecay(breakout_camera_velocity.y, 0, 16)

    // ease camera back to the center of the game
    breakout_camera.target.x = ExpDecay(breakout_camera.target.x, BREAKOUT_CAMERA_FOCUS.x, 3)
    breakout_camera.target.y = ExpDecay(breakout_camera.target.y, BREAKOUT_CAMERA_FOCUS.y, 3)
}
