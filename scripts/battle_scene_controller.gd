extends Node

var enemy_creature: CreatureBase = null
var player_creature: CreatureBase = null

	
func generate_random_enemy_creature():
	enemy_creature = BattleHandler.GetRandomEnemyCreature()
	

