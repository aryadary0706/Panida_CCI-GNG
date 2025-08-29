extends PanelContainer
@onready var health: Label = $MarginContainer/HealthMoneyInfo/Healthbox/Health
@onready var money: Label = $MarginContainer/HealthMoneyInfo/Moneybox/Money


func _ready() -> void:
	# tampilkan nilai awal
	health.text = str(Global.Health)
	money.text = str(Global.Money)

	# connect ke signal biar otomatis update
	Global.money_changed.connect(update_money)
	Global.health_changed.connect(update_health)

func update_money(new_value: int) -> void:
	money.text = str(new_value)

func update_health(new_value: int) -> void:
	health.text = str(new_value)
