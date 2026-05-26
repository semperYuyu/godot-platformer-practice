local player = {
	extends = CharacterBody2D,
	direction = Vector2,
	speed = 100,
	velocity_y = 0,
	gravity = 500,
	jump_strength = 250,
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
		print("what the heck")
		reload_timer:start()
	end
-- // shooting
end


function player:_physics_process(delta)
	self:get_input(delta)
	self.velocity = Vector2(self.direction * self.speed, self.velocity_y)
	-- // can not manipulate self.velocity.x/y directly; can't set them to any value by referencing as 
	-- // self.velocity.y = [value]; have to do from self.velocity itself
	self:move_and_slide()
end

return player
