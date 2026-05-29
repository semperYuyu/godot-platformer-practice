local player = {
	extends = CharacterBody2D,
	direction = Vector2.ZERO,
	speed = 100,
	velocity_y = 0,
	gravity = 500,
	jump_strength = 250,
	shoot = signal("position", "direction"),
}
function player:_ready()
	reload_timer = self:get_node("ReloadTimer")
end



player.get_input = function(self, delta)
-- // movement
	self.direction = Input:get_axis("left", "right")
	-- // get_axis returns a float rather than a Vector2 object, has to be turned into one to manipulate velocity
	if Input:is_action_just_pressed("jump") then
		self.velocity_y = -self.jump_strength
	else
		self.velocity_y = self.velocity_y + self.gravity * delta
	end
-- // movement


-- // shooting
	if Input:is_action_just_pressed("shoot") and reload_timer.time_left == 0 then
		local MarkerSprite2D = self:get_node("MarkerSprite2D")
		self.shoot:emit(self.position, self:get_local_mouse_position():normalized())
		-- // local mouse position is relative to self (player)
		-- // normalized makes it 1/-1 so that bullet speed is always the same regardless of distance clicked from player
		reload_timer:start()
		local tween = self:get_tree():create_tween()

		tween:tween_property(MarkerSprite2D, "scale", Vector2(0.05, 0.05), 0.1)
		tween:tween_property(MarkerSprite2D, "scale", Vector2(0.5, 0.5), 0.4)

	end
-- // shooting

end

player.update_marker = function(self)
	local MarkerSprite2D = self:get_node("MarkerSprite2D")
	MarkerSprite2D.position = self:get_local_mouse_position():normalized() * 40
end

function player:_physics_process(delta)
	self:get_input(delta)
	self.velocity = Vector2(self.direction * self.speed, self.velocity_y)
	-- // can not manipulate self.velocity.x/y directly; can't set them to any value by referencing as
	-- // self.velocity.y = [value]; have to do from self.velocity itself
	self:move_and_slide()
	self:animation()
	self:update_marker()
end

function player:animation()
	local AnimationPlayer = self:get_node("AnimationPlayer")
	local LegsSprite2D = self:get_node("LegsSprite2D")

	LegsSprite2D.flip_h = self.velocity.x < 0 and true or false
	if self:is_on_floor() then
		AnimationPlayer.current_animation = self.velocity.x ~= 0 and 'run' or 'idle'
	else
		AnimationPlayer.current_animation = 'jump'
	end

	-- // --
		local TorsoSprite2D = self:get_node("TorsoSprite2D")
		local mouse_pos = self:get_local_mouse_position():normalized()
		local adjusted_mouse_pos = Vector2i(round(mouse_pos.x), round(mouse_pos.y))
		local key = adjusted_mouse_pos.x .. "," .. adjusted_mouse_pos.y
		-- i can't set a Vector2 object as a key... so i have to turn the data into a string to search in dictionary
		gun_directions = {
		["1,0"] = 0,
		["1,1"] = 1,
		["0,1"] = 2,
		["-1,1"] = 3,
		["-1,0"] = 4,
		["-1,-1"] = 5,
		["0,-1"] = 6,
		["1,-1"] = 7,
	}

		TorsoSprite2D.frame = gun_directions[key]
	-- // --
end

return player
