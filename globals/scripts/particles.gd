extends Node


@export var explosion_particles: PackedScene = preload('res://particles/explosion/explosion_particles.tscn')
@export var implosion_particles: PackedScene = preload('res://particles/implosion/implosion_particles.tscn')


var explosives_counter: int = 1
var implosion_counter: int = 1


func spawn_explosives(global_position: Vector2, global_rotation: float) -> void:
    var particles: GPUParticles2D = explosion_particles.instantiate()

    particles.global_position = global_position
    particles.global_rotation = global_rotation
    particles.emitting = true

    particles.name = &'Explosive Particles ' + str(explosives_counter)
    explosives_counter += 1

    get_tree().current_scene.add_child(particles)


func spawn_implosion(global_position: Vector2, global_rotation: float) -> void:
    var particles: GPUParticles2D = implosion_particles.instantiate()

    particles.global_position = global_position
    particles.global_rotation = global_rotation
    particles.emitting = true

    particles.name = &'Implosion Particles ' + str(implosion_counter)
    implosion_counter += 1

    get_tree().current_scene.add_child(particles)
