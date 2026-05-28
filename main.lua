grass=0
water=1

-- Base Sprites
grass_spr=128
water_spr=131

-- Grass Sprites
tree_base_spr=134
mushroom_spr=135
tree_spr=136

-- Water Sprites
lily_pad_spr=150
rock_spr=151
trunk_spr=152 

-- Player
player_side_spr=001
player_down_spr=002
player_up_spr=003

-- Movement 

down=0
up=1
right=2
left=3



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
	draw_map()
	draw_player()
	
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
	player.x=7
	player.y=15
	player.score=0
    player.last_move=down
end

function make_map()
    timer=0
	safe_x=7
	max_y=0
	map={}
	queue_len=20
	
	row_type=0
	consecutive_rows=0
	
	for i=1, queue_len do
		add(map, create_row())
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
                    local obstacle_type = 134 + flr(rnd(3))
                    local obstacle = { x = i, type = obstacle_type, timer = 0 }
                    add(sprites, obstacle)
                else
                    if rnd() < 0.3 then bg_sprite_no = 130 + flr(rnd(4))
                    else bg_sprite_no = 128 + flr(rnd(2)) end
                    add(sprites, { x = i, type = bg_sprite_no, timer = 0 })
                end
            else
                if rnd() < 0.3 then bg_sprite_no = 130 + flr(rnd(4))
                else bg_sprite_no = 128 + flr(rnd(2)) end
                add(sprites, { x = i, type = bg_sprite_no, timer = 0 })
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
                            local opts = {lily_pad_spr, rock_spr}
                            obstacle_type = opts[flr(rnd(2)) + 1]
                        else 
                            local opts = {lily_pad_spr, rock_spr, trunk_spr}
                            obstacle_type = opts[flr(rnd(3)) + 1]
                        end
                        if obstacle_type == trunk_spr then
                            add(sprites, { x = i, type = trunk_spr, timer = 0 })
                            add(sprites, { x = i + 1, type = trunk_spr + 1, timer = 0 })
                            add(sprites, { x = i + 2, type = trunk_spr + 2, timer = 0 })
    
                            occupied_x = 3 
                        else
                            add(sprites, { x = i, type = obstacle_type, timer = 0 })
                        end
                    else
                        add(sprites, { x = i, type = 144 + flr(rnd(2)), timer = 0 })
                    end
                else
                    local obstacle_type
                    if i > 13 then
                        local opts = {lily_pad_spr, rock_spr}
                        obstacle_type = opts[flr(rnd(2)) + 1]
                    else 
                        local opts = {lily_pad_spr, rock_spr, trunk_spr}
                        obstacle_type = opts[flr(rnd(3)) + 1]
                    end
                    if obstacle_type == trunk_spr then
                        add(sprites, { x = i, type = trunk_spr, timer = 0 })
                        add(sprites, { x = i + 1, type = trunk_spr + 1, timer = 0 })
                        add(sprites, { x = i + 2, type = trunk_spr + 2, timer = 0 })
    
                        occupied_x = 3 
                    else
                        add(sprites, { x = i, type = obstacle_type, timer = 0 })
                    end    
                end
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
    if player.last_move==down then
        spr(player_down_spr, 8*player.x, 8*player.y)
    elseif player.last_move==up then
        spr(player_up_spr, 8*player.x, 8*player.y)
    elseif player.last_move==right then
        spr(player_side_spr, 8*player.x, 8*player.y)
    elseif player.last_move==left then
        spr(player_side_spr, 8*player.x, 8*player.y, 1.0, 1.0, true, false)
    end
end

function draw_map()
    local draw_y = 15
    for row in all(map) do
        for s in all(row.sprites) do
            spr(s.type, 8 * s.x, 8 * draw_y)
        end
        draw_y -= 1
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
    local current_player_x = player.x
    local current_player_y = player.y

    if btnp(0) then
        player.x -= 1
        player.last_move=left
    elseif btnp(1) then
        player.x += 1
        player.last_move=right
    elseif btnp(2) then
        player.y -= 1
        player.last_move=up
    elseif btnp(3) then
        player.y += 1
        player.last_move=down
    end
    
    player.x = mid(0, player.x, 15)
    player.y = mid(0, player.y, 15)

    if not check_legal_move() then
        player.x = current_player_x
        player.y = current_player_y
    end

    player.score = max_y
end

function check_legal_move()
    local row_to_check = map[16 - player.y]
    if not row_to_check then return false end

    for sprite in all(row_to_check.sprites) do
        if sprite.x == player.x then
            sprite_to_check = sprite.type
            break
        end
    end

    if sprite_to_check == nil then return false end
    return fget(sprite_to_check, 0)

end

function update_map()
end

function check_alive()
end