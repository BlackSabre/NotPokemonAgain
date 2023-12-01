extends Node

var battle_type: BattleType.Type = BattleType.Type.UNKNOWN
var enemy_creature: CreatureBase = null
var player_creature: CreatureBase = null


func generate_random_enemy_creature():
	pass
	

func start_random_encounter(enemy_creature: CreatureBase):
	enemy_creature = enemy_creature
	battle_type = BattleType.Type.RANDOM_ENCOUNTER


func end_random_encounter():
	pass
