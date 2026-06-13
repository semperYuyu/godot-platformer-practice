local drone = {
	extends = CharacterBody2D;
	health = 3;
	playerDetected = false;
	speed = 50;
	direction = Vector2.ZERO;
	death = false;
}


drone.explode = function (self)
	self.death = true
	self:get_node("DroneSprite"):hide()
	self:get_node("DetectArea"):queue_free()
	self:get_node("ExplosionSprite"):show()
  self:get_node("ExplosionSprite/AnimationPlayer"):play('default')
	self:get_node("DespawnTimer"):start()
end


function drone:_ready()
	print('ready !!!')
	Player = self:get_node("/root/Level/Entities/Player")
	DroneSprite = self:get_node("./DroneSprite")

end


function drone:_physics_process(deltaTime)
	if self.playerDetected and not self.death then
		-- start MOVIN
		self.direction = (Player.position - self.position):normalized()
		self.velocity = self.direction * self.speed
		self:move_and_slide()

	end
end


function drone:_on_detect_area_body_entered()
	print('hoooooly heck')
	self.playerDetected = true
	DetectArea:queue_free()
end

function drone:_on_drone_hurtbox_body_entered(player)
	-- detects player
	if not self.death then
		print('\'splosion !')
		self:explode()
	end

end

function drone:_on_drone_hurtbox_area_entered(bullet)
	-- detects bullet
	print("owieee")
	self.health = self.health - 1
	ModulateTween = self:get_tree():create_tween()
	ModulateTween:tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2):from(Color(1, 0, 0, 0.7))

	if self.health <= 0 then
		self:explode()
	end
end

function drone:_on_despawn_timer_timeout()
	self:queue_free()
end

return drone
