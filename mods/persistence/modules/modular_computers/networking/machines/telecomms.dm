/obj/machinery/network/telecomms_hub
	req_access = null

// Channels are serialized as lists, see channel_wrapper.dm
SAVED_VAR(/obj/machinery/network/telecomms_hub, channels)
SAVED_VAR(/obj/machinery/network/telecomms_hub, overloaded_for)

// Radio and encryption key saving. Channels are intentionally not saved - they are recovered at runtime by transmit/receive functions.
/obj/item/radio/Initialize()
	// Hackiness to prevent trying to create new keys. Could be replaced with checks upstream
	if(persistent_id && length(encryption_keys))
		var/list/old_encryption_keys = encryption_keys.Copy()
		encryption_keys.Cut()
		. = ..()
		encryption_keys = old_encryption_keys
	else
		return ..()

/obj/item/radio/after_deserialize()
	encryption_key_capacity = max(encryption_key_capacity, length(encryption_keys))
	. = ..()

SAVED_VAR(/obj/item/radio, cell)
SAVED_VAR(/obj/item/radio, wires)
SAVED_VAR(/obj/item/radio, panel_open)
SAVED_VAR(/obj/item/radio, encryption_keys)
SAVED_VAR(/obj/item/radio, on)
SAVED_VAR(/obj/item/radio, frequency)
SAVED_VAR(/obj/item/radio, traitor_frequency)
SAVED_VAR(/obj/item/radio, broadcasting)
SAVED_VAR(/obj/item/radio, listening)
SAVED_VAR(/obj/item/radio, analog)
SAVED_VAR(/obj/item/radio, analog_secured)

SAVED_VAR(/obj/item/radio/beacon, code)
SAVED_VAR(/obj/item/radio/beacon, functioning)
SAVED_VAR(/obj/item/radio/intercom/locked, locked_frequency)
SAVED_VAR(/obj/item/encryptionkey, can_decrypt) //Can vary at runtime