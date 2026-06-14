local level = {
	extends = Node2D,
}

function level:_ready()
	bullet_scene = ResourceLoader:load("res://scenes/bullets/bullet.tscn")
	print(self:get_tree():get_nodes_in_group("Drones"))

	local point_light_2 = self:get_node("PointLight2D2")
	local light_tween = self:get_tree():create_tween()

	light_tween:set_loops()
	light_tween:tween_property(point_light_2, "energy", 1.5, 1)
	light_tween:tween_property(point_light_2, "energy", 0.5, 0.5)
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
