#define MESSAGE_SERVER_SPAM_REJECT 1
#define MESSAGE_SERVER_DEFAULT_SPAM_LIMIT 10

var/global/list/obj/machinery/message_server/message_servers = list()

/datum/data_pda_msg
	var/recipient = "Unspecified" //name of the person
	var/sender = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message

/datum/data_pda_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "")

	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message

/datum/data_rc_msg
	var/rec_dpt = "Unspecified" //name of the person
	var/send_dpt = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "",var/param_stamp = "",var/param_id_auth = "",var/param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(1)
				priority = "Normal"
			if(2)
				priority = "High"
			if(3)
				priority = "Extreme"
			else
				priority = "Undetermined"

/obj/machinery/message_server
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100

	var/list/datum/data_pda_msg/pda_msgs = list()
	var/list/datum/data_rc_msg/rc_msgs = list()
	var/active = 1
	var/decryptkey = "password"

	//Spam filtering stuff
	var/list/spamfilter = list("You have won", "your prize", "male enhancement", "shitcurity", \
			"are happy to inform you", "account number", "enter your PIN")
			//Messages having theese tokens will be rejected by server. Case sensitive
	var/spamfilter_limit = MESSAGE_SERVER_DEFAULT_SPAM_LIMIT	//Maximal amount of tokens

/obj/machinery/message_server/New()
	message_servers += src
	decryptkey = GenerateKey()
	send_pda_message("System Administrator", "system", "This is an automated message. The messaging system is functioning correctly.")
	..()
	return

/obj/machinery/message_server/Destroy()
	message_servers -= src

	return ..()

/obj/machinery/message_server/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

/obj/machinery/message_server/Process()
	//if(decryptkey == "password")
	//	decryptkey = generateKey()
	if(active && (stat & (BROKEN|NOPOWER)))
		active = 0
		return
	update_icon()
	return

/obj/machinery/message_server/proc/send_pda_message(var/recipient = "",var/sender = "",var/message = "")
	var/result
	for (var/token in spamfilter)
		if (findtextEx(message,token))
			message = "<font color=\"red\">[message]</font>"	//Rejected messages will be indicated by red color.
			result = token										//Token caused rejection (if there are multiple, last will be chosen>.
	pda_msgs += new/datum/data_pda_msg(recipient,sender,message)
	return result

/obj/machinery/message_server/proc/send_rc_message(var/recipient = "",var/sender = "",var/message = "",var/stamp = "", var/id_auth = "", var/priority = 1, var/id_name = "", var/id_rank = "", var/stamp_name = "")		//Eclipse edit: Added ID name, rank, and stamp name for Discord passthrough
	rc_msgs += new/datum/data_rc_msg(recipient,sender,message,stamp,id_auth)
	var/authmsg = "[message]<br>"
	if (id_auth)
		authmsg += "[id_auth]<br>"
	if (stamp)
		authmsg += "[stamp]<br>"
	
	// // // BEGIN ECLIPSE EDIT // // //
	//NT Department Alarm Dispatcher
	if(world.time >= SSdispatcher.cooldown)		//If we're not in cooldown, pass it along
		SSdispatcher.handle_request(recipient, priority, message, id_name, id_rank, stamp_name)
	else		//we're still in cooldown, log it and carry on.
		var/cooldown_left = round((SSdispatcher.cooldown - world.time) / 10, 0.1)		//round it to tenth-seconds
		if(SSdispatcher.debug_level > 2)		//if debugging is on
			log_debug("DISPATCHER/message_server.dm: Messaging server still in dispatch cooldown for [cooldown_left] seconds.")
	// // // END ECLIPSE EDIT // // //
	
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if (ckey(Console.department) == ckey(recipient))
			if(Console.inoperable())
				Console.message_log += "<B>Message lost due to console failure.</B><BR>Please contact [station_name()] system adminsitrator or AI for technical assistance.<BR>"
				continue
			if(Console.newmessagepriority < priority)
				Console.newmessagepriority = priority
				Console.icon_state = "req_comp[priority]"
			switch(priority)
				if(2)
					if(!Console.silent)
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						Console.audible_message(text("\icon[Console] *The Requests Console beeps: 'PRIORITY Alert in [sender]'"),,5)
					Console.message_log += "<B><FONT color='red'>High Priority message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></FONT></B><BR>[authmsg]"
				else
					if(!Console.silent)
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						Console.audible_message(text("\icon[Console] *The Requests Console beeps: 'Message from [sender]'"),,4)
					Console.message_log += "<B>Message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></B><BR>[authmsg]"
			Console.set_light(2)


/obj/machinery/message_server/attack_hand(user as mob)
//	user << "\blue There seem to be some parts missing from this server. They should arrive on the station in a few days, give or take a few CentCom delays."
	to_chat(user, "You toggle PDA message passing from [active ? "On" : "Off"] to [active ? "Off" : "On"]")
	active = !active
	update_icon()

	return

/obj/machinery/message_server/attackby(obj/item/O as obj, mob/living/user as mob)
	if (active && !(stat & (BROKEN|NOPOWER)) && (spamfilter_limit < MESSAGE_SERVER_DEFAULT_SPAM_LIMIT*2) && \
		istype(O,/obj/item/electronics/circuitboard/message_monitor))
		spamfilter_limit += round(MESSAGE_SERVER_DEFAULT_SPAM_LIMIT / 2)
		user.drop_item()
		qdel(O)
		to_chat(user, "You install additional memory and processors into message server. Its filtering capabilities been enhanced.")
	else
		..(O, user)

/obj/machinery/message_server/on_update_icon()
	if((stat & (BROKEN|NOPOWER)))
		icon_state = "server-nopower"
	else if (!active)
		icon_state = "server-off"
	else
		icon_state = "server-on"

	return




var/obj/machinery/blackbox_recorder/blackbox

/obj/machinery/blackbox_recorder
	name = "blackbox recorder"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "blackbox"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100
	var/list/messages = list()		//Stores messages of non-standard frequencies


	var/list/msg_common = list()
	var/list/msg_science = list()
	var/list/msg_command = list()
	var/list/msg_medical = list()
	var/list/msg_engineering = list()
	var/list/msg_security = list()
	var/list/msg_deathsquad = list()
	var/list/msg_syndicate = list()
	var/list/msg_cargo = list()
	var/list/msg_service = list()
	var/list/msg_nt = list()



	//Only one can exist in the world!
/obj/machinery/blackbox_recorder/Initialize(mapload, d)
	. = ..()
	if(blackbox && istype(blackbox,/obj/machinery/blackbox_recorder))
		return INITIALIZE_HINT_QDEL
	blackbox = src

/obj/machinery/blackbox_recorder/Destroy()
	var/turf/T = locate(1,1,2)
	if(T)
		blackbox = null
		var/obj/machinery/blackbox_recorder/BR = new/obj/machinery/blackbox_recorder(T)
		BR.msg_common = msg_common
		BR.msg_science = msg_science
		BR.msg_command = msg_command
		BR.msg_medical = msg_medical
		BR.msg_engineering = msg_engineering
		BR.msg_security = msg_security
		BR.msg_deathsquad = msg_deathsquad
		BR.msg_syndicate = msg_syndicate
		BR.msg_cargo = msg_cargo
		BR.msg_service = msg_service
		BR.msg_nt = msg_nt

		BR.messages = messages

		if(blackbox != BR)
			blackbox = BR
	. = ..()

// Sanitize inputs to avoid SQL injection attacks
proc/sql_sanitize_text(var/text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text
