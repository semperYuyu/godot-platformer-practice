local bullet = {
	extends = Area2D,
	speed = 1000,
	setup = function (self, position, direction)
		self.position = position
		self.direction = direction
		return
	end,
}

function bullet:_ready()
	local scale_tween = self:get_tree():create_tween()
	scale_tween:tween_property(self, "scale", Vector2(1, 1), 0.2):from(Vector2.ZERO)

	local laser_sound_player = self:get_node("LaserSoundPlayer")
	local laser_sound_file = ResourceLoader:load("res://audio/laser.wav")

	laser_sound_player.stream = laser_sound_file
	laser_sound_player:play()
end

function bullet:_physics_process(delta)
	self.position = self.position + (self.direction * self.speed * delta)
end

function bullet:_on_despawn_timer_timeout()
	self:queue_free()
end

return bullet
