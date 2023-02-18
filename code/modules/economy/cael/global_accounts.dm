// Global accounts accessible from anywhere. Basically, the default player and station accounts accessible through ATMs
/proc/create_glob_account(var/account_name = "Default account name", var/owner_name, var/starting_funds = 0, var/account_type = ACCOUNT_TYPE_PERSONAL, var/obj/machinery/computer/account_database/source_db)

	//create a new account
	var/datum/money_account/M = new()
	M.account_name = account_name
	M.owner_name = (owner_name ? owner_name : account_name)
	M.account_type = account_type
	M.remote_access_pin = rand(1111, 111111)

	//create an entry in the account transaction log for when it was created
	//note that using the deposit proc on the account isn't really feasible because we need to change the transaction data before performing it
	var/datum/transaction/singular/T = new(M, (source_db ? source_db.machine_id : "NTGalaxyNet Terminal #[rand(111,1111)]"), starting_funds, "Account creation")
	if(!source_db)
		//set a random date, time and location some time over the past few decades
		T.date = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [global.using_map.game_year - rand(8,18)]"
		T.time = "[rand(0,24)]:[rand(11,59)]"

		M.account_id = random_id("station_account_number", 111111, 999999)
	else
		M.account_id = next_account_number
		next_account_number += rand(1,25)

		//create a sealed package containing the account details
		var/txt
		txt += "<b>Account details (confidential)</b><br><hr><br>"
		txt += "<i>Account holder:</i> [M.owner_name]<br>"
		txt += "<i>Account number:</i> [M.format_account_id()]<br>"
		txt += "<i>Account pin:</i> [M.remote_access_pin]<br>"
		txt += "<i>Starting balance:</i> [M.format_value_by_currency(M.money)]<br>"
		txt += "<i>Date and time:</i> [stationtime2text()], [stationdate2text()]<br><br>"
		txt += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
		txt += "<i>Authorised officer overseeing creation:</i> [source_db.held_card.registered_name]<br>"

		var/obj/item/paper/R = new /obj/item/paper(null, null, txt, "Account information: [M.account_name]")
		R.apply_custom_stamp(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_stamp-boss", flags = RESET_COLOR), "by the Accounts Database")
		new /obj/item/parcel(source_db.loc, null, R)

	//add the account
	T.perform()
	SSmoney_accounts.all_glob_accounts.Add(M)

	return M

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(var/attempt_account_id, var/attempt_pin_number, var/valid_card)
	var/datum/money_account/D = get_glob_account(attempt_account_id)
	if(D && (D.security_level != 2 || valid_card) && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
		return D

/proc/get_glob_account(var/account_id)
	for(var/datum/money_account/D in SSmoney_accounts.all_glob_accounts)
		if(D.account_id == account_id)
			return D
