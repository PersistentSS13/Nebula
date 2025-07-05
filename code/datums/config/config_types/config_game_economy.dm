/decl/configuration_category/game_economy
	name = "Game Economy"
	desc = "Configuration options relating to the game economy."
	associated_configuration = list(
		/decl/config/num/withdraw_period,
		/decl/config/num/interest_period,
		/decl/config/num/interest_mod_delay,
		/decl/config/num/withdraw_mod_delay,
		/decl/config/num/transaction_mod_delay,
		/decl/config/num/fractional_reserve_mod_delay,
		/decl/config/num/anti_tamper_mod_delay,
	)

// Economy variables
/decl/config/num/withdraw_period
	uid = "withdraw_period"
	desc = "Duration in deciseconds. Default is 24h (864,000 deciseconds)"
	default_value = 1 DAY
	rounding = 1

/decl/config/num/interest_period
	uid = "interest_period"
	desc = "Duration in deciseconds. Default is 24h (864,000 deciseconds)"
	default_value = 1 DAY
	rounding = 1

/decl/config/num/interest_mod_delay
	uid = "interest_mod_delay"
	desc = "Duration in deciseconds. Default is 48h (1,728,000 deciseconds)"
	default_value = 2 DAYS
	rounding = 1

/decl/config/num/withdraw_mod_delay
	uid = "withdraw_mod_delay"
	desc = "Duration in deciseconds. Default is 72h (2,592,000 deciseconds)"
	default_value = 3 DAYS
	rounding = 1

/decl/config/num/transaction_mod_delay
	uid = "transaction_mod_delay"
	desc = "Duration in deciseconds. Default is 48h (1,728,000 deciseconds)"
	default_value = 2 DAYS
	rounding = 1

/decl/config/num/fractional_reserve_mod_delay
	uid = "fractional_reserve_mod_delay"
	desc = "Duration in deciseconds. Default is 72h (2,592,000 deciseconds)"
	default_value = 3 DAYS
	rounding = 1

/decl/config/num/anti_tamper_mod_delay
	uid = "anti_tamper_mod_delay"
	desc = "Duration in deciseconds. Default is 48h (1,728,000 deciseconds)"
	default_value = 2 DAYS
	rounding = 1
