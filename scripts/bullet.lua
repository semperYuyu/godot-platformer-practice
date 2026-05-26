local bullet = {
	extends = Area2D,
	speed = 1000,
	setup = function (self, position, direction)
		self.position = position
		self.direction = direction
		return
	end,
}

function bullet:_physics_process(delta)
	self.position = self.position + (self.direction * self.speed * delta)
end

function bullet:_on_despawn_timer_timeout()
	self:queue_free()
end

return bullet
