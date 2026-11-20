package main

import "vendor:curl"
import rand "core:math/rand"
import "core:c"
import "core:fmt"
import r "vendor:raylib"

window_width:i32: 750;
window_height :i32: 750;
font_size :i32: 10;
speed :i32: 25
radius :i32: 32
key :r.KeyboardKey



snake :: struct {
    x : i32,
    y : i32,
    width : i32,
    height : i32,
    color : r.Color,
    body_count: i32
}

apple :: struct {
    x : i32,
    y : i32,
    radius : i32,
    color : r.Color
}

main :: proc() {
    game()
}

game_loop :: proc () {

    snake_body := new([dynamic]^snake)

    text :cstring = "Snake"

    // create snake 
    snake_object := snake{x = 0, y = 0, width = 25, height = 25, color = r.GREEN}
    append(snake_body, &snake_object)

    // create apple
    apple_object := apple{ x = rand.int32_range(0 , window_width), y = rand.int32_range(0, window_height), radius = 20, color = r.RED }

    textSize := r.MeasureText(text, font_size*3)

    x :i32 = 0
    y :i32 = 0

    for !r.WindowShouldClose(){
    
        r.BeginDrawing();

         // redraw background
        r.ClearBackground(r.BLACK)

        r.DrawText(text, ((window_width/2) - (textSize/2)), 10 , font_size * 3, r.GREEN)

        r.DrawCircle(apple_object.x, apple_object.y, cast(f32)apple_object.radius, apple_object.color)

        // head moving
        keyboard_controls(snake_body[0])
        r.DrawRectangle(snake_body[0].x , snake_body[0].y, snake_body[0].width, snake_body[0].height, snake_body[0].color)
        
                                                            //1  2.  3.  4.   
        // set each body part to x and y of earlier body part   a -> b ->c 
                                                            //a->b->c  
        for i := len(snake_body)-1 ; i > 0 ; i-=1{
            snake_body[i].x = snake_body[i-1].x 
            snake_body[i].y = snake_body[i-1].y 
        }

        for i := 1; i < len(snake_body); i+=1 {
             r.DrawRectangle(snake_body[i].x , snake_body[i].y, snake_body[i].width, snake_body[i].height, snake_body[i].color)
        }
        

        if touch_apple(&snake_object, &apple_object) {
            respawn_apple(&apple_object)

            new_snake := new(snake)

            // get last item of the array aka the current one 
            current := snake_body[len(snake_body)-1]

            new_snake.x = current.x
            new_snake.y = current.y
            new_snake.height = current.height
            new_snake.width = current.width
            new_snake.color = current.color

            append(snake_body, new_snake)
        }

        // create bounadries
        check_boundaries(snake_body[0])

        r.EndDrawing();
    }
}

keyboard_controls :: proc(body: ^snake ) {

            if r.IsKeyPressed(r.KeyboardKey.S) {
                key = r.KeyboardKey.S
            }
            if r.IsKeyDown(r.KeyboardKey.W) {
                key = r.KeyboardKey.W
            }
            if r.IsKeyDown(r.KeyboardKey.D) {
                key = r.KeyboardKey.D
            }
            if r.IsKeyDown(r.KeyboardKey.A) {
               key = r.KeyboardKey.A
            }

                #partial switch (key) {
                    case r.KeyboardKey.S:
                        body.y = body.y + speed 
                    case r.KeyboardKey.W:
                        body.y = body.y - speed 
                    case r.KeyboardKey.D:
                        body.x = body.x + speed
                    case r.KeyboardKey.A:
                        body.x = body.x - speed
                }
    }

touch_apple :: proc(snake_o: ^snake, apple_o: ^apple) -> bool {

    overlapping_r := apple_o^.radius -5

    if (snake_o^.x + snake_o^.width >= apple_o^.x - overlapping_r && snake_o^.x <= apple_o^.x + overlapping_r) && (snake_o^.y + snake_o^.height >= apple_o^.y - overlapping_r && snake_o^.y <= apple_o^.y + overlapping_r)  {
        fmt.println("eaten apple")
        return true
    }

    return false
}

respawn_apple :: proc(apple_o: ^apple) {
            apple_o.x = rand.int32_range(0, window_width - radius)
            apple_o.y = rand.int32_range(0, window_height - radius)
}


check_boundaries :: proc(snake_o: ^snake) {
    textSize := r.MeasureText("gameover", font_size*5)

    if snake_o^.x >= window_width - snake_o^.width || snake_o^.x <= 0 {
        if snake_o^.x <= 0 {
            snake_o^.x = 0 + snake_o.width
        } else {
            snake_o^.x = window_width - snake_o^.width
        }
        r.DrawText("gameover", ((window_width/2) - (textSize/2)), (window_height/2 - + 50/2) , font_size * 5, r.RED)
    }

    if snake_o^.y >= window_height - snake_o^.height || snake_o^.y <= 0 {
        if snake_o^.y <= 0 {
            snake_o^.y = 0 + snake_o.height
        } else {
            snake_o^.y = window_height - snake_o^.height
        }
        r.DrawText("gameover", ((window_width/2) - (textSize/2)), (window_height/2 - + 50/2) , font_size * 5, r.RED)
    }
}


game :: proc() {
    r.InitWindow(window_width, window_height, "game")
    r.SetTargetFPS(20)

    // main game loop
    game_loop()


}


