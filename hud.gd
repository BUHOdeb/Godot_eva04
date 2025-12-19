extends CanvasLayer

@export var heart_texture: Texture2D
@export var coin_texture: Texture2D

@onready var hearts_container: HBoxContainer = $Control/Hearts
@onready var coins_container: HBoxContainer = $Control/Coins

func _ready():
	# Seguridad básica
	if not GameManager.hud_updated.is_connected(update_hud):
		GameManager.hud_updated.connect(update_hud)

	update_hud()

func update_hud():
	_update_hearts()
	_update_coins()

# -----------------------------
# Corazones (vidas)
# -----------------------------
func _update_hearts():
	if hearts_container == null:
		push_error("HUD: Hearts container no encontrado")
		return

	# Limpiar
	for child in hearts_container.get_children():
		child.queue_free()

	# Crear corazones
	for i in range(GameManager.lives):
		var heart := TextureRect.new()
		heart.texture = heart_texture
		heart.custom_minimum_size = Vector2(24, 24)
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hearts_container.add_child(heart)

# -----------------------------
# Monedas
# -----------------------------
func _update_coins():
	if coins_container == null:
		push_error("HUD: Coins container no encontrado")
		return

	# Limpiar
	for child in coins_container.get_children():
		child.queue_free()

	# Crear monedas
	for i in range(GameManager.coins):
		var coin := TextureRect.new()
		coin.texture = coin_texture
		coin.custom_minimum_size = Vector2(20, 20)
		coin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		coin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		coins_container.add_child(coin)
