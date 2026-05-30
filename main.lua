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
    max_difficulty_reached=false
    difficulty_level=30
	make_player()
	make_map()
end

function _update()
	if(not game_over) then
        map_counter+=1
        player_counter+=1
        
		update_player()
		update_map()
        update_difficulty()
	elseif btnp((5)) then _init()
	end
end

function _draw()
	cls()
	draw_map()
	draw_player()
	
	if (game_over) then 
        rectfill(0,0,128,128,0)
		print("game over!", 44, 44, 7)
		print("your score:"..player.score,34,54,7)
		print("press ❎ to play again!",18,72,6)
	else
		print("score:"..player.score,2,2,7)
	end
end

-->8
function make_player()
    player_counter=0
	player={}
	player.x=7
	player.y=15
	player.score=0
    player.last_move=down
end

function make_map()
    map_counter=0
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

    if player_counter >= difficulty_level then
        if player.y == 15 then
            game_over=true
        end
        player.y+=1
        player.score+=1
        player_counter = 0
    end 
    
end


function update_map()
    if map_counter >= difficulty_level then
        add_row()
        map_counter=0
    end
end

function update_difficulty()
    if max_difficulty_reached then
        return
    else
        difficulty_level = 30 - flr(player.score/2)
        if difficulty_level < 8 then
            difficulty_level = 8
            max_difficulty_reached = true
        end
    end
end
