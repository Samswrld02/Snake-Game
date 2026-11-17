package main

import "core:time"
import "core:fmt"
import r "vendor:raylib"

window_width:i32: 500;
window_height :i32: 500;
font_size :i32: 10;
speed :i32: 5

main :: proc() {
    game()
}

game_loop :: proc () {

    text :cstring = "Snake"

    fmt.println(text);

    textSize := r.MeasureText(text, font_size*3)

    x :i32 = 0
    y :i32 = 0

    for !r.WindowShouldClose(){
        r.BeginDrawing();
        r.DrawText(text, ((window_width/2) - (textSize/2)), 10 , font_size * 3, r.GREEN)

        r.DrawCircle(x, y, 32.0, r.RED)
        
        r.EndDrawing();
        
        // redraw background
        r.ClearBackground(r.BLACK)

        // handle keyboard controls
        keyboard_controls(&x, &y)
    }
}

keyboard_controls :: proc(x: ^i32, y: ^i32) {
        if r.IsKeyDown(r.KeyboardKey.S) {
            y^ = y^ + speed
        }
        if r.IsKeyDown(r.KeyboardKey.W) {
            y^ = y^ - speed
        }
         if r.IsKeyDown(r.KeyboardKey.D) {
            x^ = x^ + speed
        }
        if r.IsKeyDown(r.KeyboardKey.A) {
            x^ = x^ - speed
        }
    }


game :: proc() {
    r.InitWindow(window_width, window_height, "game")
    r.SetTargetFPS(60)

    // main game loop
    game_loop()
}


