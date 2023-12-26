extends Node

const BATTLE_UI_PATH: String = "/root/BattleScene/BattleUI"
const SCREEN_EFFECTS_PATH: String = "/root/BattleScene/ScreenEffects"
const PLAYER_NODE_PATH: String = "/root/BattleScene/BattleUI/UICanvas/PlayerCreature"
const ENEMY_NODE_PATH: String = "/root/BattleScene/BattleUI/UICanvas/EnemyCreature"

var battle_ui: BattleUI = null
var screen_effects: CanvasLayer = null
var battle_type: BattleType.Type = BattleType.Type.UNKNOWN
var enemy_creature: CreatureForBattle
var player_creature: CreatureForBattle

#var enemy_creature: CreatureBase = null
#var player_creature: CreatureBase = null


func start_random_encounter(_enemy_creature: CreatureBase) -> void:
	#player_creature_node.set_creature_and_ui(PlayerData.get_first_creature(), true)
	#enemy_creature_node.set_creature_and_ui(enemy_creature, false)
	battle_type = BattleType.Type.RANDOM_ENCOUNTER


func get_player_creature_moveset() -> CreatureMovesetBase:
	return player_creature.creature.moveset
	#return player_creature.moveset


func get_player_creature() -> CreatureBase:
	if player_creature.creature == null:
		player_creature.set_creature_and_ui(PlayerData.get_first_creature())
		
	return player_creature.creature


func get_enemy_creature() -> CreatureBase:	
	#Below for debug
	if enemy_creature == null:
		find_relevant_nodes()
	
	if enemy_creature.creature == null:
		var random_route: Routes.Route = generate_random_route()
		print_debug("Could not find enemy_creature in BattleSceneController. Generating random creature for route: ", random_route)
		var new_enemy_creature: CreatureBase = BattleSetupHandler.get_random_enemy_creature(random_route)
		new_enemy_creature.current_health = new_enemy_creature.base_health
		enemy_creature.set_creature_and_ui(new_enemy_creature, false)
		
	return enemy_creature.creature


func get_enemy_creature_node() -> CreatureForBattle:
	get_enemy_creature()
	return enemy_creature
	

func get_player_creature_node() -> CreatureForBattle:
	return player_creature


func end_random_encounter() -> void:
	pass


# below function for debug, shouldn't be called normally
func generate_random_route() -> Routes.Route:
	var routes: Array = Routes.Route.keys()
	routes.remove_at(0) # first route always UNKNOWN
	var random_route: Routes.Route = Routes.Route[routes.pick_random()]
	
	return random_route


func _creature_attack(_attacker: CreatureForBattle, move: MoveBase, target: CreatureForBattle) -> void:
	var damage: int = move.damage	
	target.creature.update_health(damage)
	
	if target.creature.is_dead:
		print_debug("Target has died")
	

func enemy_creature_died() -> void:
	pass


# called from battle_ui when it's instantiated
func connect_battle_ui_signals() -> void:
	if battle_ui == null:
		battle_ui = get_node(BATTLE_UI_PATH)

	battle_ui.on_creature_attack.connect(_creature_attack)	


# called from ScreenEffects when it's instantiated
func connect_screen_effects_signals() -> void:
	if screen_effects == null:
		screen_effects = get_node(SCREEN_EFFECTS_PATH)
	
	#screen_effects.on_shake_finished().connect


func find_relevant_nodes() -> void:
	enemy_creature = get_node(ENEMY_NODE_PATH)
	player_creature = get_node(PLAYER_NODE_PATH)
	battle_ui = get_node(BATTLE_UI_PATH)
	screen_effects = get_node(SCREEN_EFFECTS_PATH)
