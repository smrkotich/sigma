extends Sprite2D

var DisplayName = "i7-2600 Processor"
var desc = "Makes godo2s twice as efficient."
var cost = 5000

func condition_check():
	var checked = false
	
	if $"../../godoot".overallGododadots >= 100:
		checked = true
	
	return checked
