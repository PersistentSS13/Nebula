///Frequency for disposals machinery
var/global/const/DISPOSALS_FREQ = 1382

/decl/stock_part_preset/radio/receiver/recycler
	frequency        = DISPOSALS_FREQ
	receive_and_call = list(
		"power_toggle" = /decl/public_access/public_method/toggle_power,
	)
