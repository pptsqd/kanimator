class_name AnimNames
extends Node

#S and E are left and right?
var anim_names = [
	#shared_basic_a_01.anim
	"idle", 
	"run", 
	"snk", 
	"walk", 
	"walk180", 
	#shared_basic_a_02.anim
	"heal", 
	"heal_team", 
	"door_peek_pre", 
	"door_peek_pst", 
	"use_comp", 
	"get_up", 
	"get_up_pst", 
	"get_up", 
	"revive", 
	"pin_stab", 
	#shared_basic_a_03.anim
	"peek_fwrd", 
	"peek_pst_fwrd", 
	"peek_bwrd", 
	"peek_pst_bwrd", 
	"hide_pre", 
	"hide", 
	"hide_pst", 
	"lean_pre", 
	"lean", 
	"lean_pst", 
	#shared_basic_a_04.anim
	"overwatch_pre", 
	"overwatch", 
	"overwatch_idle", 
	"overwatch_trans", 
	"overwatch_switch", # ( "overwatch_switch_"..facing, oldFacing) but uses odd numbers so check the code
	#shared_basic_a_05.anim
	"peek_", 
	"hide_peek_pst_", 
	"hide_peek_pst_", 
	"lean_peek_pre_", 
	"lean_peek_pst_", 
	"hide_walk_", 
	"hide_walk_pst_",  #all these peeks hae L and R versions?
	"lean_overwatch_pre", 
	"lean_overwatch_pst", 
	#shared_basic_a_06.anim
	"smoke_idle", 
	"smoke", 
	"phone_idle", 
	"phone", 
	#martial_basic_b_01.anim
	"shoot_pre", 
	"shoot_pst", 
	"shootburst_pre", 
	"shootburst_pst", 
	"cover_pre", 
	"cover", 
	"shootcover_pre", 
	"shootcover_pst", 
	"cover_stand", 
	"cover_run", 
	#"Poses", #idk if this is an anim or not it is in all files
	#martial_basic_b_02.anim
	"use_door", 
	"use_door_pst", 
	"pick_up", 
	"tinker", 
	"tinker_pst", 
	"shrug", 
	"tinker_loop", 
	"poses", 
	#martial_basic_b_03.anim
	"hitfrt_pst", 
	"hitbck_pst", 
	"idle_pre", 
	"snk_pst", 
	"walk_pre", 
	"walk_pst", 
	"pin_pre", 
	"pin", 
	"pin_stand", 
	#martial_basic_b_04.anim
	"run_pst", 
	"smoke_pre", 
	"smoke_pst", 
	"phone_pre", 
	"phone_pst", 
	#shared_attacks_a_01.anim
	"shoot", 
	"shootburst", #unused?
	"shootcover", #unused?
	"reload", 
	"hide_reload", 
	"lean_reload", 
	#shared_attacks_a_02.anim
	"melee", 
	"melee_pst", 
	"melee_grp_pre", 
	"melee_grp", 
	"ground_taze", 
	#shared_attacks_a_03.anim
	"throw", 
	"throw_pst", 
	"hide_throw_", # L AND R
	"hide_throw_pst_", # L AND R
	"lean_throw_", # L AND R
	"lean_throw_pst_", # L AND R
	"door_kick_pre", 
	"door_kick_pst", 
	#shared_attacks_a_04.anim
	"pinshoot_pre", 
	"pinshoot", 
	"pinshoot_pst", 
	#shared_attacks_b_01.anim
	"shootcover", 
	#shared_basic_a_07.anim
	"overwatchcrouch_pre", 
	"overwatchcrouch_idl", 
	"overwatchcrouch_pst", 
	#shared_basic_b_03.anim
	"trans", #maybe unused
	#shared_basic_c_04.anim 
	"overwatch_melee_pre", 
	"overwatch_melee", 
	"overwatch_melee_pre", 
	#shared_basic_c_05.anim
	"lean_meleeoverwatch", 
	#"overwatchcrouch_mel", 
	#shared_drag_01.anim
	"body_pick_up", 
	"body_pick_up", 
	"body_drag", 
	"body_drag_pst", 
	"body_drag_idle", 
	#shared_drop_a_01.anim
	"body_drop", 
	#shared_hits_01.anim 
	"hitfrt", 
	"hitbck", 
	"death", 
	"dead",  
	"body_fall", 
	"downed_taze", 
	"downed_hit", 
	"untie_idle", 
	"untie", 
	#stealth_basic_a_05.anim
	"cover_idle", 
	"shootcover_idle", 
	]


#raw data
#["#martial_basic_b_01.anim", "idle", "shoot_pre", "shoot_pst", "shootburst_pre", "shootburst_pst", "cover_pre", "cover", "shootcover_pre", "shootcover_pst", "cover_stand", "cover_run", "Poses", "#martial_basic_b_02.anim", "use_door", "use_door_pst", "pick_up", "tinker", "tinker_pst", "shrug", "tinker_loop", "poses", "#martial_basic_b_03.anim", "hitfrt_pst", "hitbck_pst", "idle_pre", "snk_pst", "walk_pre", "walk_pst", "pin_pre", "pin", "pin_stand", "#martial_basic_b_04.anim", "run_pst", "smoke_pre", "smoke_pst", "phone_pre", "phone_pst", "#panic_basic_c_01.anim", "#panic_basic_c_02.anim", "#panic_basic_c_03.anim", "#shared_attacks_a_01.anim", "shoot1", "shootburst1", "shootburst2", "shootburst3", "shootburst4", "shootcover1", "reload", "hide_reload", "lean_reload", "#shared_attacks_a_02.anim", "melee", "melee_pst", "melee_grp_pre", "melee_grp", "ground_taze", "#shared_attacks_a_03.anim", "throw", "throw_pst", "hide_throw_L", "hide_throw_pst_L", "hide_throw_R", "hide_throw_pst_R", "lean_throw_R", "lean_throw_pst_R", "lean_throw_L", "lean_throw_pst_L", "door_kick_pre", "door_kick_pst", "#shared_attacks_a_04.anim", "pinshoot_pre", "pinshoot", "pinshoot_pst", "#shared_attacks_b_01.anim", "shoot2", "shoot3", "shootcover2", "shootcover3", "#shared_attacks_b_02.anim", "#shared_attacks_b_03.anim", "#shared_attacks_b_04.anim", "#shared_attacks_c_01.anim", "#shared_attacks_c_02.anim", "#shared_basic_a_01.anim", "run", "snk", "walk", "walk180", "#shared_basic_a_02.anim", "heal", "heal_team", "door_peek_pre", "door_peek_pst", "use_comp", "get_up_ESE_", "get_up_pstNES", "get_upS_", "revive", "pin_stab", "#shared_basic_a_03.anim", "peek_fwrd", "peek_pst_fwrd", "peek_bwrd", "peek_pst_bwrd", "peek_fwrd_W_", "peek_pst_fwrd_W_", "peek_fwrd_NW_", "peek_pst_fwrd_NW_", "peek_fwrd_N_", "peek_pst_fwrd_N_", "hide_pre", "hide", "hide_pst", "lean_pre", "lean", "lean_pst", "#shared_basic_a_04.anim", "overwatch_pre_ESE_", "overwatch_ESE_", "overwatch_idle_ESE_", "overwatch2_pre", "overwatch2_idle", "overwatch2_pst", "overwatch3_pre", "overwatch3_idle", "overwatch3_pst", "overwatch_trans", "overwatch_switch_7_ESE_", "overwatch_switch_6_ESE_", "overwatch_switch_5_ESE_", "overwatch_switch_0_ESE_", "overwatch_switch_1_ESE_", "overwatch_switch_2_ESE_", "overwatch_switch_3_ESE_", "overwatch_switch_4_ESE_", "overwatch_preS_", "overwatchS_", "overwatch3", "overwatch_switch_6S_", "overwatch_switch_5S_", "overwatch_switch_4S_", "overwatch_switch_3S_", "overwatch_switch_7S_", "overwatch_switch_0S_", "overwatch_switch_1S_", "overwatch_switch_2S_", "#shared_basic_a_05.anim", "hide_peek_pre_R", "peek_R", "hide_peek_pst_R", "hide_peek_pre_L", "peek_L", "hide_peek_pst_L", "lean_peek_pre_R", "lean_peek_pst_R", "lean_peek_pre_L", "lean_peek_pst_L", "hide_walk_L", "hide_walk_pst_L", "hide_walk_R", "hide_walk_pst_R", "lean_overwatch_pre", "lean_overwatch_pst", "#shared_basic_a_06.anim", "smoke_idle", "smoke", "phone_idle", "phone", "#shared_basic_a_07.anim", "overwatchcrouch_preS_", "overwatchcrouch_idlS_", "overwatchcrouch_pstS_", "overwatchcrouch_pre_ESE_", "overwatchcrouch_idl_ESE_", "overwatchcrouch_pst_ESE_", "#shared_basic_b_01.anim", "#shared_basic_b_02.anim", "#shared_basic_b_03.anim", "trans", "Trans", "#shared_basic_b_04.anim", "overwatch3_pre_E", "#shared_basic_b_05.anim", "#shared_basic_b_06.anim", "#shared_basic_b_07.anim", "#shared_basic_c_01.anim", "walk180_NW_", "walk180_W_", "#shared_basic_c_02.anim", "#shared_basic_c_03.anim", "#shared_basic_c_04.anim", "overwatch_melee_pre_ESE_", "overwatch_melee_ESE_", "overwatch_melee_preS_", "overwatch_meleeS_", "#shared_basic_c_05.anim", "lean_meleeoverwatch", "#shared_basic_c_06.anim", "#shared_basic_c_07.anim", "overwatchcrouch_melS_", "overwatchcrouch_mel_ESE_", "#shared_drag_01.anim", "body_pick_up_ENW", "body_pick_up_WS_", "body_drag", "body_drag_pst", "body_drag_idle", "#shared_drag_02.anim", "#shared_drop_a_01.anim", "body_drop", "body_drop_W_", "body_drop_NW_", "#shared_drop_a_02.anim", "#shared_drop_b_01.anim", "#shared_drop_b_02.anim", "#shared_drop_c_01.anim", "#shared_drop_c_02.anim", "#shared_hits_01.anim", "hitfrt", "hitbck", "death_ENW", "dead_ENW", "death_WS_", "dead_WS_", "body_fall_WS_", "body_fall_ENW", "downed_taze_WS_", "downed_taze_ENW", "downed_hit_WS_", "downed_hit_ENW", "#stealth_basic_a_01.anim", "#stealth_basic_a_02.anim", "#stealth_basic_a_03.anim", "#stealth_basic_a_04.anim", "untie_idle", "untie", "#stealth_basic_a_05.anim", "cover_idle", "shootcover_idle", "#tech_basic_a_01.anim", "#tech_basic_a_02.anim", "#tech_basic_a_03.anim", "pin_stand_E", "#tech_basic_a_04.anim", "#unarmed_basic_a_01.anim", "#unarmed_basic_a_02.anim", "#unarmed_basic_a_03.anim", "#unarmed_basic_a_04.anim", "#unarmed_basic_a_05.anim", "overwatchcrouch_mel"]
