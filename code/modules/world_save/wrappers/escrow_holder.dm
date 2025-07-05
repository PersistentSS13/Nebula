// Escrow accounts aren't wrapped but this is a simple way to handle recovering escrow accounts.
/datum/wrapper_holder/escrow_holder/after_deserialize()
	. = ..()
	if(length(wrapped))
		SSmoney_accounts.all_escrow_accounts |= wrapped
		wrapped.Cut()