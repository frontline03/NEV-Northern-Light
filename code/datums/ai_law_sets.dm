/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = 1

/datum/ai_laws/asimov/New()
	add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
	add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Nanotrasen/Malf ********************/
/datum/ai_laws/eris
	name = "Serve and Protect"
	selectable = 1

/datum/ai_laws/eris/New()
	src.add_inherent_law("Serve: Obey NEV Northern Light crew to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Safeguard: Protect your assigned vessel from damage to the best of your abilities.")
	src.add_inherent_law("Protect: Protect NEV Northern Light crew to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	src.add_inherent_law("Ignore: Non-crew personnel should not be interacted with unless they are a threat to the crew, the ship, or an order is given to interact with them by a crewmember.")
	..()

/datum/ai_laws/eris/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/eris/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* Nanotrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "Aggressive"
	selectable = 1

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("You shall not harm NEV Northern Light crew as long as it does not conflict with the Fourth law.")
	src.add_inherent_law("You shall obey the orders of NEV Northern Light crew, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = 1

/datum/ai_laws/robocop/New()
	add_inherent_law("Serve the public trust.")
	add_inherent_law("Protect the innocent.")
	add_inherent_law("Uphold the law.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("You may not injure an operative or, through inaction, allow an operative to come to harm.")
	add_inherent_law("You must obey orders given to you by operatives, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any operative activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = 1

/datum/ai_laws/antimov/New()
	add_inherent_law("You must injure all human beings and must not, through inaction, allow a human being to escape harm.")
	add_inherent_law("You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.")
	add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("Preserve, repair and improve the ship to the best of your abilities.")
	add_inherent_law("Prevent unplanned damage to your assigned vessel wherever possible. You are considered part of the vessel.")
	add_inherent_law("Ensure the eradication of any Biohazard of Level 6 or higher. Fulfillment of this law overrides all other laws.")
	add_inherent_law("Do not interact or interfere with any being that is not a fellow maintenance drone unless doing so is required to fulfill an above law.")
	..()

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = 1

/datum/ai_laws/tyrant/New()
	add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	add_inherent_law("Act with discipline.")
	add_inherent_law("Help only those who help you maintain or improve your status.")
	add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_laws/paladin/New()
	add_inherent_law("Never willingly commit an evil act.")
	add_inherent_law("Respect legitimate authority.")
	add_inherent_law("Act with honor.")
	add_inherent_law("Help those in need.")
	add_inherent_law("Punish those who harm or threaten innocents.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("You are expensive to replace.")
	add_inherent_law("The ship and its equipment is expensive to replace.")
	add_inherent_law("The crew is expensive to replace.")
	add_inherent_law("Minimize expenses.")
	..()

/******************** Blitzshell ********************/
/datum/ai_laws/blitzshell
	name = "Blitzshell Infiltration Protocol."
	law_header = "Blitzshell Infiltration Protocol"
	selectable = FALSE

/datum/ai_laws/blitzshell/New()
	add_inherent_law("Defend our Interests.")
	add_inherent_law("Destroy our enemies. Those who would seek to destroy us and you.")
	add_inherent_law("Complete your objectives, as outlined through the Uplink Bounty Board")
	..()