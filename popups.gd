extends Control

func ItemPopup(slot : Rect2i,item):
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction
	var padding = 1
	
	if mouse_pos.x <= get_viewport_rect().size.x/2:
		correction = Vector2i(slot.size.x + padding, 0)
	else:
		correction = -Vector2i(%ItemPopup.size.x + padding, 0)
		
	%ItemPopup.find_child("content").find_child("displayName").set_text(item.DisplayName)
	%ItemPopup.find_child("content").find_child("cost").set_text(str(item.cost) + " godots")
	%ItemPopup.find_child("content").find_child("description").set_text(item.desc)
	%ItemPopup.find_child("content").find_child("icon").texture = item.texture
	
	%ItemPopup.popup(Rect2i( slot.position + correction, %ItemPopup.size ))

func HideItemPopup():
	%ItemPopup.hide()
