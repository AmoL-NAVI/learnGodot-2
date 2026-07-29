extends Node

var equipment: Dictionary[String, EquipData] = {
	"helmet": null,
	"weapon": null,
	"body": null,
	"legs": null,
	"ring": null,
}

var skill_slots: Array[SkillData] = [
	null, null, null, null
]

var coins: float = 500.0
