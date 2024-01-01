pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
 
-- vim /Users/pandaming/Library/Application\ Support/pico-8/carts/puzzle_bubble.p8

-- random color for current ball based on whats there
-- draw dragon and reverse dragon jumping on the sides

-- figure out why bug overwrite variable happens
-- the last ball overrides the others
-- be careful reusing variable names 
-- clean up and plan for next run

    stuck_balls = {}
    possible_balls = {}

    function _init()
        ball_speed = 2
        arrow_dir = 90
        bal_dir = dir
        ball_pad = 2
        degree_incr = 4
        box_y_start = 10
        box_y_end = 100
        box_x_start = 32 
        box_x_end = 97
        h = 10
        possible_c = 15
        ah = 3
        bh = 7
        shoot = false
        box_c = 7
        back_c = 7
        line_c = 5
        get_level_one()
        get_possible_balls()
        reload()
        ball_swap_color = 2
        last_drop_time = 0
        drop_ball_speed = 3
        collide_dist = 9
        max_level = 1
        move_num = 1
    end
    
    function get_next_level() 
        level = level + 1
        if level > 4 then level = 1 end
        max_level = level
        restart_level()
    end

    function restart_level()
        stuck_balls = {}
        box_y_start = 10
        if level == 1 then
            get_level_one()
        elseif level == 2 then
            get_level_two()
        elseif level == 3 then
           get_level_three()
        elseif level == 4 then
	   get_level_four()
        else
            get_level_one()
        end
        last_drop_time = 0
        move_num = 1
        get_possible_balls()
    end

    function restart_max_level()
        level = max_level
        restart_level()
    end

    function get_level_one()
        level = 1

        for i=3,5 do
            ipball  = { x = box_x_start + 1 + i * 8 , y = box_y_start + 1, c = 11 }
            if (not is_in_balls(stuck_balls, ipball)) then
                stuck_balls[#stuck_balls+1] = ipball
            end
        end
    end  

    function get_level_two()
        level = 2

        for i=3,4 do
            ipball  = { x = box_x_start + 1 + i * 8 , y = box_y_start + 1, c = 11 }
            if (not is_in_balls(stuck_balls, ipball)) then
                stuck_balls[#stuck_balls+1] = ipball
            end
        end

        for i=3,3 do
              ipball  = { x = box_x_start + 1 + 4 + i * 8 , y = box_y_start + 8 +  1, c = 14 }
              if (not is_in_balls(stuck_balls, ipball)) then
                  stuck_balls[#stuck_balls+1] = ipball
              end
         end
    end

    function get_level_three()
        level = 3
        for i=0,7 do
            ipball  = { x = box_x_start + 1 + i * 8 , y = box_y_start + 1, c = get_random_c() }
            if (not is_in_balls(stuck_balls, ipball)) then
                stuck_balls[#stuck_balls+1] = ipball
            end
        end
    end

    function get_level_four()
        level = 4

        for i=0,7 do
            ipball  = { x = box_x_start + 1 + i * 8 , y = box_y_start + 1, c = get_random_c() }
            if (not is_in_balls(stuck_balls, ipball)) then
                stuck_balls[#stuck_balls+1] = ipball
            end
        end
    end

    function get_possible_balls()
        possible_balls = {}
        for i=0,7 do
            ipball  = { x = box_x_start + 1 + i * 8 , y = box_y_start + 1, c = possible_c }
            if (not is_in_balls(stuck_balls, ipball)) then
                possible_balls[#possible_balls+1] = ipball
            end
        end
        for i, isball in ipairs(stuck_balls) do
            get_surround_possible_ball(isball)
        end
    end

    function check_ball_collision()
        s = 0 
        for i, ball in ipairs(possible_balls) do
            iDist = balls_dist(ball, { x = ball_x, y = ball_y })            
            if (iDist < collide_dist) then 
               s = i
            end
        end
        
        if s > 0 then
            stick_ball(s)
            reload()
            shoot = false
        end
    end

    function stick_ball(i)
        ball = possible_balls[i]
        ball.c = ball_c
        add(stuck_balls, ball)
        same_color_balls = {}
        traversed_balls = {}
        drop_balls = {}
        find_same_color_balls(ball, ball_c)
        if #same_color_balls > 2 then
            remove_same_color_balls()
            find_orphaned_balls()
            is_dropping_balls = true
            last_drop_time = time()
        end
        get_possible_balls()
        move_num = move_num + 1
        if move_num % 6 == 0 and level == 4 then
            shift_balls_down_one()
        end
    end    

    function shift_balls_down_one()
        for _, ball in ipairs(stuck_balls) do
            ball.y = ball.y + 8
        end

        for _, ball in ipairs(possible_balls) do
            ball.y = ball.y + 8
        end

        box_y_start = box_y_start + 8
    end
   
    function find_orphaned_balls()
        traversed_balls = {}
        
        for i=0,7 do
            ipball  = { x = box_x_start + 1 + i * 8 , y = box_y_start + 1, c = possible_c }
            if (is_in_balls(stuck_balls, ipball)) then
                find_same_color_balls(ipball, -1)
            end
        end
        
        temp_stuck_balls = {}
        for _, ball in ipairs(stuck_balls) do
            if (is_in_balls(traversed_balls, ball)) then
                add(temp_stuck_balls, ball)
            else
                add(drop_balls, ball)
            end
        end
        stuck_balls = temp_stuck_balls
        debug = #stuck_balls
    end

    function remove_same_color_balls()
        for _, ball in ipairs(same_color_balls) do
            del(stuck_balls, ball)
            add(drop_balls, ball)
        end
    end

    function find_same_color_balls(ball, c)
        if is_in_balls(traversed_balls, ball) or not is_valid_ball(ball) or not is_in_balls(stuck_balls, ball) or is_in_balls(same_color_balls, ball) then
            if (ball.x == 33) then
--                 debug = 123
             end
            return
        end

        add(traversed_balls, ball)        

	if get_stuck_ball(ball) > -1 then
            stuck_ball = stuck_balls[get_stuck_ball(ball)]
          
            if (stuck_ball.c == c or c == -1) then             
                add(same_color_balls, stuck_ball)
                find_same_color_balls({ x = ball.x - 4, y = ball.y + 8}, c)
                find_same_color_balls({ x = ball.x + 4, y = ball.y + 8}, c)
                find_same_color_balls({ x = ball.x - 8, y = ball.y }, c)
                find_same_color_balls({ x = ball.x + 8, y = ball.y }, c)
                find_same_color_balls({ x = ball.x - 4, y = ball.y - 8}, c)
                find_same_color_balls({ x = ball.x + 4, y = ball.y - 8}, c)
            end
	end

    end

    function is_valid_ball(ball)
        return ball.x > box_x_start and ball.x + 4 < box_x_end and ball.y > box_y_start
    end

    function get_surround_possible_ball(ball)
        add_possible_ball({ x = ball.x - 4, y = ball.y + 8, c = possible_c})
        add_possible_ball({ x = ball.x + 4, y = ball.y + 8, c = possible_c}) 
    end

    function add_possible_ball(ball)
        if (ball.x > box_x_start and ball.x + 4 < box_x_end) then
            if (not is_in_balls(possible_balls,ball) and not is_in_balls(stuck_balls, ball)) then
                add(possible_balls, ball)
            end
        end 
    end

    function get_stuck_ball(ball)
        for i, pball in ipairs(stuck_balls) do
             if (ball.x == pball.x and ball.y == pball.y) then
                 return i
             end
        end
        return -1
    end

    function is_in_balls(balls, ball)
        for _, pball in ipairs(balls) do
             if (ball.x == pball.x and ball.y == pball.y) then
                 return true
             end
        end
        return false
    end

    function reload()
        ball_x = 61
        ball_y = box_y_end
        if next_ball_c == nil then
            ball_c = get_random_possible_c()
        else
            ball_c = next_ball_c
        end
        next_ball_c = get_random_possible_c()
       
    end

    function has_color(p_colors, color)
         for i, c in ipairs(p_colors) do
            if color == c then
                return true
            end
         end
         return false
    end

    function get_random_possible_c()
         if level == 2 or level == 1 then
             return 11 
         end

         possible_colors = {}
         for i, pball in ipairs(stuck_balls) do
             if not has_color(possible_colors, pball.c) then
                  possible_colors[#possible_colors+1] = pball.c       
             end    
         end
        random_c = 11
 
        if #possible_colors > 0 then
            i  = flr(rnd(#possible_colors)) + 1
            random_c =  possible_colors[i]
        end
        return random_c

    end

    function get_random_c()
        rand = flr(rnd(6))
        if rand == 0 then 
            return 11
        elseif rand == 1 then
            return 12
        elseif rand == 2 then
            return 14
        elseif rand == 3 then
            return 9
        elseif rand == 4 then
            return 4
        else
            return 6
        end
    end

    function balls_dist(ballA, ballB)
        dist = sqrt((ballA.x - ballB.x)*(ballA.x - ballB.x) + (ballA.y - ballB.y)*(ballA.y - ballB.y))
        return dist
    end

   function get_min_y_drop_balls()
       min_y = 200

       for _, ball in ipairs(drop_balls) do
           if (ball.y < min_y) then
               min_y = ball.y
           end
       end
       return min_y
   end

   function is_game_over()
       for _, ball in ipairs(stuck_balls) do
           if ball.y > box_y_end then
               return true
           end
       end

       return false
   end
   function _update()

        if is_game_over() then
            restart_max_level()
        end

        if (is_dropping_balls and get_min_y_drop_balls() > 130) then
            get_possible_balls()
            is_dropping_balls = false
            shoot = false
            drop_balls = {}
            
            if #stuck_balls == 0 then
                get_next_level()
            end
        end
         
      
        if (is_dropping_balls) then
            for _, ball in ipairs(drop_balls) do
               ball.y = ball.y + drop_ball_speed
            end
            return
        end   

        if (not shoot and btnp(0) and arrow_dir < 170) arrow_dir = arrow_dir + degree_incr
        if (not shoot and btnp(1) and arrow_dir > 10 ) arrow_dir = arrow_dir - degree_incr
        if (not shoot and btnp(4)) then
	         shoot = true
                 ball_dir = arrow_dir
	end
        if (shoot) then
		ball_x = ball_x + cos(ball_dir/360) * ball_speed
		if (ball_y - ball_pad > box_y_start) then
        			ball_y = ball_y + sin(ball_dir/360) * ball_speed
		end
        end
        if (ball_x - 2 < box_x_start) ball_dir = 180 - ball_dir
        if (ball_x + 7 > box_x_end) ball_dir = 180 - ball_dir
        check_ball_collision()
    end
    
    function draw_arrow()
        line(64, 103, 64 + cos(arrow_dir/360)*h, 103 + sin(arrow_dir/360)*h)
        arrow_px = 64 + cos(arrow_dir/360)*h
        arrow_py = 103 + sin(arrow_dir/360)*h
        line(arrow_px, arrow_py , arrow_px + 1 * cos((arrow_dir + 135)/360)*ah,  arrow_py + sin((arrow_dir + 135)/360)*ah)
        line(arrow_px, arrow_py , arrow_px + 1 * cos((arrow_dir - 135)/360)*ah,  arrow_py + sin((arrow_dir - 135)/360)*ah)
        line(64, 103, 64 + cos((arrow_dir + 180)/360)*bh, 103 + sin((arrow_dir+ 180)/360)*bh)        
    end

    function _draw()
        cls(back_c)
        draw_grid()
        draw_arrow()
        pal(ball_swap_color,ball_c)
        spr(3, ball_x, ball_y)
        
        pal(ball_swap_color,next_ball_c)
        spr(3, 61, box_y_end + 15)
 
        for _, ball in ipairs(stuck_balls) do
             pal(ball_swap_color,ball.c)
             spr(3, ball.x, ball.y)
        end

        for _, ball in ipairs(possible_balls) do
        --     pal(ball_swap_color,ball.c)
        --     spr(3, ball.x, ball.y)
        end

        for _, ball in ipairs(drop_balls) do
            pal(ball_swap_color,ball.c)
            spr(3, ball.x, ball.y)
        end
        
        -- print(debug, 110, 120) 
        print("level", 80, 105)
        print(level, 80, 112)
        
        if (last_drop_time != 0 and time() - last_drop_time < 5) then
            if (flr(time()*2) % 2 == 1) then
                spr(1, 40, 110)
            else 
                spr(1, 40, 109)
            end
        else
            spr(1, 40, 109)
        end
    end

    function draw_grid()
       rectfill(box_x_start, box_y_start, box_x_end, box_y_end, box_c)
       color(line_c)
       line(box_x_start, box_y_start, box_x_start, box_y_end)
       line(box_x_end, box_y_start, box_x_end, box_y_end)
       line(box_x_start, box_y_start, box_x_end, box_y_start)
       line(box_x_start, box_y_end, box_x_end, box_y_end)
       if box_y_start != 10 then
           rectfill(box_x_start, 10, box_x_end, box_y_start, 0)
       end
    end

__gfx__
00000000000033000000000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000003bbb00880088002772220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700003b5b500888888027722222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700003bbbbbb0888888027222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770003bbbbbb00088880022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700bbb999b00088880022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5995000008800002222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5595500000000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010101010303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010103030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
