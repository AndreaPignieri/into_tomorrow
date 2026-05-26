grass=0
water=1
tree_base=2
tree=3
mushroom=4
trunk=5
lily_pad=6
rock=7

grass_spr=128
water_spr=131

tree_base_spr=134
mushroom_spr=135
tree_spr=136
trunk_spr_1=152
trunk_spr_2=153
trunk_spr_3=154
lily_pad_spr=150
rock_spr=151



function _init()
	game_over=false
	make_player()
	make_map()
end

function _update()
	if(not game_over) then
		update_player()
		update_map()
		check_alive()
	elseif btnp((5)) then _init()
	end
end

function _draw()
	cls()
	draw_player()
	draw_map()
	
	if (game_over) then 
		print("game over!", 44, 44, 7)
		print("your score:"..player.score,34,54,7)
		print("press ❎ to play again!",18,72,6)
	else
		print("score:"..player.score,2,2,7)
	end
end

-->8
function make_player()
	player={}
	player.x=0
	player.y=0
	player.score=0
end

function make_map()
	safe_x=7
	max_y=0
	mappa={}
	queue_len=20
	
	row_type=0
	consecutive_rows=0
	
	for i=1, queue_len do
		add(mappa, create_row())
	end
end

function create_row()
	update_row_type()
	
	local row={}
	row.type=row_type
	drunken_walk()
	row.sprites=generate_sprites()
	return row
end

function drunken_walk()
	old_safe_x = safe_x
	safe_x = safe_x + (flr(rnd(3)) - 1)
	safe_x = mid(safe_x, 0, 15)
end

function generate_sprites()
    local sprites = {} 

    if row_type == grass then
        for i = 0, 15 do
            if i ~= safe_x and i ~= old_safe_x then
                if rnd() < 0.5 then
                    local obstacle_type = flr(rnd(3)) + 2
                    local obstacle = { x = i, type = obstacle_type, timer = 0 }
                    add(sprites, obstacle)
                else
                    if rnd() < 0.3 then
						bg_sprite_no = 130 + flr(rnd(4))
					else
						bg_sprite_no = 128 + flr(rnd(2))
					end
                    local bg_sprite = { x = i, type = bg_sprite_no, timer = 0 }
                    add(sprites, bg_sprite)
                end
            else
				if rnd() < 0.3 then
					bg_sprite_no = 130 + flr(rnd(4))
				else
					bg_sprite_no = 128 + flr(rnd(2))
				end
                local bg_sprite = { x = i, type = bg_sprite_no, timer = 0 }
                add(sprites, bg_sprite)
            end
        end
    end

    if row_type == water then
        local occupied_x = 0
        
        for i = 0, 15 do
            if occupied_x <= 0 then
                
                if i ~= safe_x and i ~= old_safe_x then
                    if rnd() < 0.3 then
                        local obstacle_type
                        if i > 13 then
                            obstacle_type = flr(rnd(2)) + 6
                        else 
                            obstacle_type = flr(rnd(3)) + 5
                        end
                        
                        local obstacle = { x = i, type = obstacle_type, timer = 0 }
                        add(sprites, obstacle)
                        
                        if obstacle.type == trunk then
                            occupied_x = 3 
                        end
                    else
                        local sprite_no = flr(rnd(2)) + 144
                        local sprite = { x = i, type = sprite_no, timer = 0 }
                        add(sprites, sprite)
                    end
                    
                else
                    local obstacle_type
                    if i > 13 then
                        obstacle_type = flr(rnd(2)) + 6
                    else 
                        obstacle_type = flr(rnd(3)) + 5
                    end
                    
                    local obstacle = { x = i, type = obstacle_type, timer = 0 }
                    add(sprites, obstacle)  
                    
                    if obstacle.type == trunk then
                        occupied_x = 3 
                    end
                end
                
            else
            end
            
            occupied_x -= 1
        end
    end

    return sprites
end	

function update_row_type()
	consecutive_rows+=1
	
	if consecutive_rows >= 3 then
		local change_probability=(consecutive_rows - 2) * 0.1
		
		if rnd() < change_probability then
			row_type+=1
			row_type=row_type%2
			consecutive_rows=0
		end
	end
end

function draw_player()

end

function draw_map()
    local draw_y = 0
    for row in all(mappa) do

        for s in all(row.sprites) do
            if isBackgroundSprite(s.type) then
                spr(s.type, 8 * s.x, draw_y)
            elseif s.type == tree then
                spr(tree_spr, 8 * s.x, draw_y)
            elseif s.type == tree_base then
                spr(tree_base_spr, 8 * s.x, draw_y)
            elseif s.type == mushroom then
                spr(mushroom_spr, 8 * s.x, draw_y)
            elseif s.type == lily_pad then
                spr(lily_pad_spr, 8 * s.x, draw_y)
            elseif s.type == rock then
                spr(rock_spr, 8 * s.x, draw_y)
            elseif s.type == trunk then
                spr(trunk_spr_1, 8 * s.x, draw_y)
                spr(trunk_spr_2, 8 * (s.x + 1), draw_y)
                spr(trunk_spr_3, 8 * (s.x + 2), draw_y)
            end
        end
        draw_y += 8
    end
end

function isBackgroundSprite(sprite_no)
	if (sprite_no >= 128 and sprite_no <= 133) or (sprite_no >= 144 and sprite_no <= 149) then
		return true
	else
		return false
	end
end

function update_player()
end

function update_map()
end

function check_alive()
end