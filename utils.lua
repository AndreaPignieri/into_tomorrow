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


function isBackgroundSprite(sprite_no)
	if (sprite_no >= 128 and sprite_no <= 133) or (sprite_no >= 144 and sprite_no <= 149) then
		return true
	else
		return false
	end
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

function add_row()
    deli(map, 1)
    add(map, create_row())
end

