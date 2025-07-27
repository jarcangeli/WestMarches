extends MarginContainer

@onready var name_label: Label = %NameLabel
@onready var damage_done_label: Label = %DamageDoneLabel
@onready var damage_received_label: Label = %DamageReceivedLabel
@onready var crit_done_label: Label = %CritDoneLabel
@onready var thorns_done_label: Label = %ThornsDoneLabel
@onready var poison_done_label: Label = %PoisonDoneLabel
@onready var aoe_done_label: Label = %AOEDoneLabel
@onready var snipe_done_label: Label = %SnipeDoneLabel
@onready var healing_label: Label = %HealingLabel

func set_data(data : CharacterCombatSummary):
	name_label.text = data.character_name
	damage_done_label.text = str(data.total_damage_done())
	damage_received_label.text = str(data.total_damage_received())
	healing_label.text = str(data.healing)
	crit_done_label.text = str(data.damage_received[CharacterCombatSummary.Stat.CRIT_DAMAGE])
	thorns_done_label.text = str(data.damage_received[CharacterCombatSummary.Stat.THORNS_DAMAGE])
	poison_done_label.text = str(data.damage_received[CharacterCombatSummary.Stat.POISON_DAMAGE])
	aoe_done_label.text = str(data.damage_received[CharacterCombatSummary.Stat.AOE_DAMAGE])
	snipe_done_label.text = str(data.damage_received[CharacterCombatSummary.Stat.SNIPE_DAMAGE])
