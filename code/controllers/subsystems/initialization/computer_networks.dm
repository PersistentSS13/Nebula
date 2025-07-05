#define MAX_CONNECTION_ATTEMPTS 5

/datum/proc/handle_post_network_connection()
	return

SUBSYSTEM_DEF(networking)
	name = "Computer Networks"
	priority = SS_PRIORITY_COMPUTER_NETS
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 2 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/networks = list()
	var/list/connection_queue = list()
	var/list/tmp_queue = list()
	/// Assoc list of network_id -> queue of devices that need to reconnect. This is checked when a new network is made.
	var/list/list/reconnect_queues = list()

/datum/controller/subsystem/networking/fire(resumed = FALSE)
	if(!resumed)
		tmp_queue = connection_queue.Copy()
		connection_queue = list()
	while(tmp_queue.len)
		try_connect(tmp_queue[tmp_queue.len])
		tmp_queue.len--
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/networking/proc/try_connect(var/datum/extension/network_device/device)

	if(QDELETED(device))
		return

	if(device.network_id)
		. = device.connect()
	else
		. = device.connect_to_any()
	if(.)
		device.holder?.handle_post_network_connection()
		device.connection_attempts = 0
	else
		if(device.connection_attempts < MAX_CONNECTION_ATTEMPTS)
			device.connection_attempts++
			connection_queue += device
		else // Maximum connection attempts reached. Do not readd to the queue.
			device.connection_attempts = 0

/datum/controller/subsystem/networking/stat_entry()
	..("[length(networks)] network\s, [length(connection_queue)] connection\s queued")

/datum/controller/subsystem/networking/proc/queue_connection(var/datum/extension/network_device/device)
	connection_queue |= device

/datum/controller/subsystem/networking/proc/queue_reconnect(var/datum/extension/network_device/device, var/network_id)
	LAZYDISTINCTADD(reconnect_queues[network_id], device)

/datum/controller/subsystem/networking/proc/unqueue_reconnect(var/datum/extension/network_device/device, var/network_id)
	LAZYREMOVE(reconnect_queues[network_id], device)

/datum/controller/subsystem/networking/proc/process_reconnections(var/network_id)
	for (var/datum/extension/network_device/device in reconnect_queues[network_id])
		if(device.network_id == network_id)
			queue_connection(device)
	LAZYCLEARLIST(reconnect_queues[network_id])

/**
	Creates the new player's network account on the map's default network. (Must have an id card for whatever reasons)
 */
/datum/controller/subsystem/networking/proc/register_player_default_network_account(mob/living/player_mob)
	var/network_id                                = global.using_map.spawn_network
	var/datum/computer_network/network            = networks[network_id]
	var/datum/computer_file/report/crew_record/CR = get_crewmember_record(player_mob.real_name)
	network.store_file(CR, MF_ROLE_CREW_RECORDS)
	network.create_account(player_mob, player_mob.real_name, null, player_mob.real_name, null, TRUE)
	return TRUE

#undef MAX_CONNECTION_ATTEMPTS