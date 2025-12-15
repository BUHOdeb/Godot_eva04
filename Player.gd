#Player.gd

extends CharacterBody2D

# ---------------- CONSTANTES ----------------
const SPEED := 250.0
const JUMP_VELOCITY := -300.0
const MAX_JUMPS := 2

# ---------------- NODOS ----------------
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grab_area: Area2D = $GrabArea
@onready var hold_point: Node2D = $HoldPoint

# ---------------- VARIABLES ----------------
var jump_count := 0
var grabbed_object: RigidBody2D = null


func _ready():
	add_to_group("player")
	GameManager.register_player(self)



# ---------------- LOOP FÍSICO ----------------
func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	handle_interaction()
	move_and_slide()
	update_animations()

# ---------------- GRAVEDAD ----------------
func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

# ---------------- SALTO ----------------
func handle_jump():
	if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

# ---------------- MOVIMIENTO ----------------
func handle_movement():
	var dir := Input.get_axis("ui_left", "ui_right")

	if dir != 0:
		velocity.x = dir * SPEED
		sprite.flip_h = dir < 0
		grab_area.position.x = 30 * dir
		hold_point.position.x = 20 * dir
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

# ---------------- INTERACCIÓN ----------------
func handle_interaction():
	if Input.is_action_just_pressed("interact"):
		if grabbed_object:
			drop_object()
		else:
			try_grab_object()

	# SOLO mientras está agarrada
	if grabbed_object:
		grabbed_object.global_position = hold_point.global_position

# ---------------- AGARRAR ----------------
func try_grab_object():
	for body in grab_area.get_overlapping_bodies():
		if body is RigidBody2D and body.is_in_group("grabbable"):
			grabbed_object = body

			# Congelar física mientras se sostiene
			grabbed_object.freeze = true
			grabbed_object.linear_velocity = Vector2.ZERO
			grabbed_object.angular_velocity = 0.0
			return

# ---------------- SOLTAR ----------------
func drop_object():
	if grabbed_object:
		grabbed_object.freeze = false

		# Pequeño empuje inicial (opcional, ajustable)
		grabbed_object.linear_velocity = Vector2(velocity.x, 30)

		grabbed_object = null

# ---------------- ANIMACIONES ----------------
func update_animations():
	if is_on_floor():
		if abs(velocity.x) < 1:
			animation_player.play("Idle")
		else:
			animation_player.play("Run")
	else:
		if velocity.y < 0:
			animation_player.play("Jump")
		else:
			animation_player.play("Fall")
