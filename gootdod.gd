extends Button

var Labl: Label 
var GpsLabl: Label
var BuildingsOwned: Node
var UpgradesOwned: Node
var Buildings: Node
var Upgrades: Node
var BuyButtons
var UpgradeContainer
var GodoBuildingScene

var Gododadots: float = 0
var overallGododadots: float = 0
var gps: float = 0
var gpc: float = 1

func _ready() -> void:
	Labl = $"../godonumber"
	BuildingsOwned = $"../BuildingsOwned"
	UpgradesOwned = $"../UpgradesOwned"
	GpsLabl = $"../godonumber2"
	GodoBuildingScene = preload("res://godobwuilding.tscn")
	Buildings = $"../Buildings"
	Upgrades = $"../Upgrades"
	BuyButtons = $"../BuyButtons"
	UpgradeContainer = $"../UpgradeContainer"
	for i in Buildings.get_child_count():
		var CurrentBuilding = Buildings.get_child(i)
		var button = $"../BuyButtons/buildingTemplate"
		
		var newButton = button.duplicate()
		BuyButtons.add_child(newButton)
		newButton.name = CurrentBuilding.name
		newButton.get_child(0).texture = load(CurrentBuilding.icon)
		newButton.get_child(1).set_text(CurrentBuilding.name)
		newButton.get_child(2).set_text(str(CurrentBuilding.cost) + " godots")
		newButton.get_child(3).set_text("owned: 0")
		newButton.visible = true
		newButton.pressed.connect(on_buybuilding_pressed.bind(newButton))
		
	for i in Upgrades.get_child_count():
		var CurrentUpgrade = Upgrades.get_child(i)
		var button = $"../UpgradeContainer/upgradeTemplate"
		
		var newButton = button.duplicate()
		UpgradeContainer.add_child(newButton)
		newButton.name = CurrentUpgrade.name
		newButton.get_child(0).texture = CurrentUpgrade.texture
		newButton.visible = true
		newButton.mouse_entered.connect(_on_upgrade_template_mouse_entered.bind(newButton,CurrentUpgrade))
		newButton.pressed.connect(on_buyupgrade_pressed.bind(newButton,CurrentUpgrade))
		newButton.mouse_exited.connect(_on_upgrade_template_mouse_exited)
		
func _on_pressed() -> void:
	give_ockies(int(gpc))

func get_ockies():
	gps = 0

	for i in BuildingsOwned.get_child_count():
		var CurrentBuilding = BuildingsOwned.get_child(i)
		gps += CurrentBuilding.OckiesGiven * CurrentBuilding.multiprier
	give_ockies(gps)

func give_ockies(ockies):
	Gododadots += ockies
	overallGododadots += ockies
	GpsLabl.set_text(str(gps) + " g/s")
	Labl.set_text(str(int(Gododadots)))

func _on_huan_second_timer_timeout() -> void:
	get_ockies()

func on_buybuilding_pressed(button):
	var CurrentBuilding = Buildings.find_child(button.name)
	if Gododadots >= CurrentBuilding.cost:
		give_ockies(CurrentBuilding.cost*-1)
		CurrentBuilding.amown += 1
		button.get_child(3).set_text("owned:" + str(CurrentBuilding.amown))
		CurrentBuilding.cost = CurrentBuilding.cost*(1.15**CurrentBuilding.amown)
		button.get_child(2).set_text(str(CurrentBuilding.cost) + " godots")
		var GodoInstance = CurrentBuilding.duplicate()
		BuildingsOwned.add_child(GodoInstance)
		var screenSize = get_viewport().get_visible_rect().size
		var rng = RandomNumberGenerator.new()
		var rndX = rng.randi_range(0, screenSize.x)
		var rndY = rng.randi_range(0, screenSize.y)
		GodoInstance.position = Vector2(rndX,rndY)
		GodoInstance.visible = true
		

func on_buyupgrade_pressed(button,upgrade):
	if Gododadots >= upgrade.cost:
		give_ockies(upgrade.cost*-1)
		Upgrades.remove_child(upgrade)
		UpgradesOwned.add_child(upgrade)
		var screenSize = get_viewport().get_visible_rect().size
		var rng = RandomNumberGenerator.new()
		var rndX = rng.randi_range(0, screenSize.x)
		var rndY = rng.randi_range(0, screenSize.y)
		upgrade.position = Vector2(rndX,rndY)
		upgrade.visible = true
		button.queue_free()
		upgrade.on_bought()
		give_ockies(0)


func _on_upgrade_template_mouse_entered(button,upgrade) -> void:
	Popups.ItemPopup(Rect2i( Vector2i(button.global_position) , Vector2i(size) ),upgrade)


func _on_upgrade_template_mouse_exited() -> void:
	Popups.HideItemPopup()

func refresh_upgrades():
	for i in Upgrades.get_child_count():
		var CurrentUpgrade = Upgrades.get_child(i)
		if not UpgradeContainer.has_node(NodePath(CurrentUpgrade.name)):
			var button = $"../UpgradeContainer/upgradeTemplate"
			
			var newButton = button.duplicate()
			UpgradeContainer.add_child(newButton)
			newButton.name = CurrentUpgrade.name
			newButton.get_child(0).texture = CurrentUpgrade.texture
			newButton.visible = true
			newButton.mouse_entered.connect(_on_upgrade_template_mouse_entered.bind(newButton,CurrentUpgrade))
			newButton.pressed.connect(on_buyupgrade_pressed.bind(newButton,CurrentUpgrade))
			newButton.mouse_exited.connect(_on_upgrade_template_mouse_exited)

func _on_upgrade_check_timer_timeout() -> void:
	var hidden_upgrades = $"../HiddenUpgrades"
	var upgrades = hidden_upgrades.get_children()
	
	for upgrade in upgrades:
		var can_unhide = upgrade.condition_check()
		if can_unhide:
			upgrade.reparent(Upgrades, true)
			
	refresh_upgrades()
