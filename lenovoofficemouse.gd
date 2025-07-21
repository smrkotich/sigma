extends Sprite2D

var DisplayName = "Lenovo Office Mouse"
var desc = "Makes clicking twice as efficient."
var cost = 500

func on_bought():
	$"../../godoot".gpc *= 2

func condition_check():
	var checked = false
	
	if $"../../godoot".overallGododadots >= 100:
		checked = true
	
	return checked
