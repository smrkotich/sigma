extends Sprite2D

var DisplayName = "DDR2 1GB Ram Stick"
var desc = "Makes godos twice as efficient."
var cost = 1000

func on_bought():
	for i in $"../../BuildingsOwned".get_child_count():
		var currentBuilding = $"../../BuildingsOwned".get_child(i)
		if currentBuilding.bkey == "godo":
			currentBuilding.multiprier = currentBuilding.multiprier*2
			currentBuilding.upgrades.append("ddr21gb")
			print("multiplier: " +str(currentBuilding.multiprier)+ ", ockies: "+ str(currentBuilding.OckiesGiven))
	$"../../BuildingsOwned".child_entered_tree.connect(on_added)

func on_added(childadded):
	print("ihihihih")
	childadded.upgrades.append("ddr21gb")
	childadded.multiprier *= 2

func condition_check():
	var checked = false
	
	var numberofSpecialBuildings = 0
	for building in $"../../BuildingsOwned".get_children():
		if building.bkey == "godo":
			numberofSpecialBuildings += 1
			
	
	if numberofSpecialBuildings >= 1:
		checked = true
	
	return checked
