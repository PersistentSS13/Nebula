/obj/machinery/fusion_fuel_injector
	var/fuel_efficiency = 10

/obj/machinery/fusion_fuel_injector/Inject()
	if(!injecting)
		return
	if(cur_assembly)
		var/amount_left = 0
		for(var/reagent in cur_assembly.rod_quantities)
			if(cur_assembly.rod_quantities[reagent] > 0)
				var/amount = cur_assembly.rod_quantities[reagent] * fuel_usage * injection_rate 
				if(amount < 1)
					amount = 1
				var/obj/effect/accelerated_particle/A = new/obj/effect/accelerated_particle(get_turf(src), dir)
				A.particle_type = reagent
				A.additional_particles = amount
				A.move(1)
				if(cur_assembly)
					cur_assembly.rod_quantities[reagent] -= amount / fuel_efficiency
					amount_left += cur_assembly.rod_quantities[reagent]
		if(cur_assembly)
			cur_assembly.percent_depleted = amount_left / cur_assembly.initial_amount
		flick("injector-emitting",src)
	else
		StopInjecting()