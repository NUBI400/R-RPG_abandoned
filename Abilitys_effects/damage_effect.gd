class_name DamageEffect
extends Effect

var amount := 0


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target.get_parent() is Enemy:
			target.get_parent().take_damage(amount)
		if target is Player:
			target.take_damage(amount)
			#SFXPlayer.play(sound)
