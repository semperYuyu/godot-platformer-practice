local level = {
	extends = Node2D,
}

function level:_ready()
	bullet_scene = ResourceLoader:load("res://scenes/bullets/bullet.tscn")
end

function level:_on_player_shoot(position, direction)
	-- // signal shoot() was created in player.lua, connected via godot gui
	local bullet_array_node = self:get_node("Bullets")
	local bullet = bullet_scene:instantiate()
	local despawn_timer = bullet:get_node("DespawnTimer")
	bullet:setup(position, direction)
	bullet_array_node:add_child(bullet)
	despawn_timer:start()
end

return level
