/obj/item/gun/projectile/boltgun
	name = "EX BR .30 \"Kardashev-Mosin\"" //Eclipse Edit - gun names standardized
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything."
	icon = 'icons/obj/guns/projectile/boltgun.dmi'
	icon_state = "boltgun"
	item_state = "boltgun"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_ROBUST
	armor_penetration = ARMOR_PEN_DEEP
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CAL_LRIFLE
	fire_delay = 8
	damage_multiplier = 1.4
	penetration_multiplier = 1.5
	recoil_buildup = 7 // increased from the AK's/Takeshi's buildup of 1.7/1.8 because of the massive multipliers and slow firerate
	init_offset = 2 //bayonet's effect on aim, reduced from 4
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	magazine_type = /obj/item/ammo_magazine/lrifle
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 900
	one_hand_penalty = 20 //full sized rifle with bayonet is hard to keep on target
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut") // Considering attached bayonet
	sharp = TRUE
	spawn_blacklisted = TRUE
	gun_parts = list(/obj/item/stack/material/steel = 16)
	saw_off = TRUE
	sawn = /obj/item/gun/projectile/boltgun/obrez
	var/bolt_open = 0
	var/item_suffix = ""

/obj/item/gun/projectile/boltgun/on_update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (item_suffix)
		itemstring += "[item_suffix]"

	if (bolt_open)
		iconstring += "_open"
	else
		iconstring += "_closed"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/boltgun/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/boltgun/attack_self(mob/user) //Someone overrode attackself for this class, soooo.
	if(zoom)
		toggle_scope(user)
		return
	bolt_act(user)

/obj/item/gun/projectile/boltgun/proc/bolt_act(mob/living/user)

	playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(contents.len)
			if(chambered)
				to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [chambered]!"))
				chambered.forceMove(get_turf(src))
				loaded -= chambered
				chambered = null
			else
				var/obj/item/ammo_casing/B = loaded[loaded.len]
				to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [B]!"))
				B.forceMove(get_turf(src))
				loaded -= B
		else
			to_chat(user, SPAN_NOTICE("You work the bolt open."))
	else
		to_chat(user, SPAN_NOTICE("You work the bolt closed."))
		playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltforward.ogg', 75, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/boltgun/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/boltgun/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/boltgun/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/boltgun/serbian
	name = "SA BR .30 \"Novakovic\""
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything. \
			This copy, in fact, is a reverse-engineered poor-quality copy of a more perfect copy of an ancient rifle"
	icon_state = "boltgun_wood"
	item_suffix  = "_wood"
	force = 23
	recoil_buildup = 7.6 // however, since it's not the excel mosin, it's not as good at recoil control, but it doesn't matter since >bolt
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	wielded_item_state = "_doble_wood"
	rarity_value = 48


//Custom item for Yeehawguvnah
/obj/item/gun/projectile/boltgun/serbian/levergun
	name = "SA BR .30 \"Greener Grass\""
	desc = "Weapon for \"hunting\". \
			If you’re on a budget, it’s a darn good rifle for just about everything. \
			This is a somewhat-modified (and visibly used) rifle, using a lever-operated action. There's an inscription on the side: \"Wish you were here\""
	icon = 'icons/vore/customguns_eclipse/levergun.dmi'
	icon_state = "levergun"
	item_state = "levergun"
	recoil_buildup = 0.4 // Double the excel variant
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	wielded_item_state = "_doble"
	rarity_value = 48
	spawn_blacklisted = FALSE
	gun_parts = list(/obj/item/stack/material/steel = 16)
	sawn = /obj/item/gun/projectile/boltgun/obrez/serbian

/obj/item/gun/projectile/boltgun/fs
	name = "FS BR .20 \"Tosshin\""
	desc = "Weapon for hunting, or endless coastal warfare. \
			Replica of an ancient bolt action known for its easy maintenance and low price."
	icon_state = "arisaka_ih"
	item_suffix  = "_arisaka_ih"
	force = WEAPON_FORCE_DANGEROUS // weaker than novakovic, but with a bayonet installed it will be slightly stronger
	armor_penetration = ARMOR_PEN_GRAZING
	caliber = CAL_SRIFLE
	damage_multiplier = 1.6
	penetration_multiplier = 1.7
	recoil_buildup = 8
	init_offset = 0 //no bayonet
	max_shells = 6
	magazine_type = /obj/item/ammo_magazine/srifle
	matter = list(MATERIAL_STEEL = 25, MATERIAL_PLASTIC = 15)
	wielded_item_state = "_doble_arisaka_ih"
	sharp = FALSE
	spawn_blacklisted = TRUE
	saw_off = FALSE
	gun_parts = list(/obj/item/stack/material/steel = 16)

/obj/item/gun/projectile/boltgun/handmade
	name = "handmade bolt action rifle"
	desc = "A handmade bolt action rifle, made from junk and some spare parts."
	icon_state = "boltgun_hand"
	item_suffix = "_hand"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5)
	wielded_item_state = "_doble_hand"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	damage_multiplier = 1.2
	penetration_multiplier = 1.3
	recoil_buildup = 9 // joonk gun
	max_shells = 5
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	price_tag = 800
	one_hand_penalty = 30 //don't you dare to one hand this
	sharp = FALSE //no bayonet here
	spawn_blacklisted = TRUE
	saw_off = FALSE

/obj/item/gun/projectile/boltgun/handmade/attackby(obj/item/W, mob/user)
	if(QUALITY_SCREW_DRIVING in W.tool_qualities)
		if(loaded.len == 0 && W.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			to_chat(user, SPAN_NOTICE("You begin to rechamber \the [src]."))
			if(caliber == CAL_LRIFLE)
				caliber = CAL_SRIFLE
				to_chat(user, SPAN_WARNING("You successfully rechamber \the [src] to .20 Caliber."))
			else if(caliber == CAL_SRIFLE)
				caliber = CAL_CLRIFLE
				to_chat(user, SPAN_WARNING("You successfully rechamber \the [src] to .25 Caseless."))
			else if(caliber == CAL_CLRIFLE)
				caliber = CAL_LRIFLE
				to_chat(user, SPAN_WARNING("You successfully rechamber \the [src] to .30 Caliber."))
		else
			to_chat(user, SPAN_WARNING("You cannot rechamber a loaded firearm!"))
			return
	..()

//// OBREZ ////

/obj/item/gun/projectile/boltgun/obrez
	name = "sawn-off EX BR .30 \"Kardashev-Mosin\"" //Eclipse Edit - gun names standardized
	desc = "Weapon for hunting, or endless trench warfare. \
	     This one has been sawed down into an \"Obrez\" style."
	icon = 'icons/obj/guns/projectile/obrez_bolt.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_WEAK // no bayonet
	armor_penetration = 0
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	penetration_multiplier = 1.1 // short barrel means maximum velocity isn't reached
	proj_step_multiplier = 1.2
	recoil_buildup = 15
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5)
	price_tag = 600
	attack_verb = list("struck","hit","bashed")
	one_hand_penalty = 10 // not a full rifle, but not easy either
	can_dual = TRUE
	sharp = FALSE
	spawn_blacklisted = TRUE
	saw_off = FALSE

/obj/item/gun/projectile/boltgun/obrez/serbian
	name = "sawn-off SA BR .30 \"Novakovic\""
	icon = 'icons/obj/guns/projectile/obrez_bolt.dmi'
	icon_state = "obrez_wood"
	item_suffix  = "_wood"
	recoil_buildup = 18
	wielded_item_state = "_doble_wood"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 5)
