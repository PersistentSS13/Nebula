/////////////////////////////////////////
// MISC SAVED
/////////////////////////////////////////
//Saved vars definitions that have no where else to go.
//#TODO: Move these to their respective files

SAVED_VAR(/zone, air)

///////////////////////////////////////////////////////////////////////////////
// ATOM
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/atom, contents) //#TODO: Use loc instead of contents.

///////////////////////////////////////////////////////////////////////////////
//ATOM/MOVABLE
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/atom/movable, dir)
SAVED_VAR(/atom/movable, pixel_x)
SAVED_VAR(/atom/movable, pixel_y)
SAVED_VAR(/atom/movable, anchored)
SAVED_VAR(/atom/movable, density)
SAVED_VAR(/atom/movable, germ_level)
SAVED_VAR(/atom/movable, was_bloodied)
SAVED_VAR(/atom/movable, level)
SAVED_VAR(/atom/movable, name)
SAVED_VAR(/atom/movable, blend_mode)
SAVED_VAR(/atom/movable, opacity)
SAVED_VAR(/atom/movable, layer)
SAVED_VAR(/atom/movable, color)
SAVED_VAR(/atom/movable, icon_state)

///////////////////////////////////////////////////////////////////////////////
//OBJ
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/obj, blood_DNA)

///////////////////////////////////////////////////////////////////////////////
//TURF
///////////////////////////////////////////////////////////////////////////////

SAVED_VAR(/turf/simulated, air)
SAVED_VAR(/turf/simulated, temperature)

SAVED_VAR(/turf/simulated/floor, burnt)
SAVED_VAR(/turf/simulated/floor, broken)

SAVED_VAR(/turf/exterior/wall, strata_override)
SAVED_VAR(/turf/exterior/wall, paint_color)
SAVED_VAR(/turf/exterior/wall, material)
SAVED_VAR(/turf/exterior/wall, reinf_material)
SAVED_VAR(/turf/exterior/wall, floor_type)

SAVED_VAR(/turf/simulated/wall, floor_type)
SAVED_VAR(/turf/simulated/wall, paint_color)
SAVED_VAR(/turf/simulated/wall, stripe_color)
SAVED_VAR(/turf/simulated/wall, damage)
SAVED_VAR(/turf/simulated/wall, material)
SAVED_VAR(/turf/simulated/wall, reinf_material)
SAVED_VAR(/turf/simulated/wall, girder_material)

///////////////////////////////////////////////////////////////////////////////
//DATUMS
///////////////////////////////////////////////////////////////////////////////

SAVED_VAR(/datum/pipeline, air)

///////////////////////////////////////////////////////////////////////////////
//MOB
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/mob/living, current_health)
SAVED_VAR(/mob/living, mob_bump_flag)
SAVED_VAR(/mob/living, mob_swap_flags)
SAVED_VAR(/mob/living, mob_push_flags)
SAVED_VAR(/mob/living, on_fire)
SAVED_VAR(/mob/living, fire_stacks)
SAVED_VAR(/mob/living, auras)
SAVED_VAR(/mob/living, job)
SAVED_VAR(/mob/living, meat_amount)
SAVED_VAR(/mob/living, skin_amount)
SAVED_VAR(/mob/living, bone_amount)
SAVED_VAR(/mob/living, reagents)
SAVED_VAR(/mob/living, _held_item_slot_selected)
SAVED_VAR(/mob/living, _held_item_slots)
SAVED_VAR(/mob/living, _inventory_slots)
SAVED_VAR(/mob/living, ticks_since_last_successful_breath)

SAVED_VAR(/mob/living/bot, on)
SAVED_VAR(/mob/living/bot, open)
SAVED_VAR(/mob/living/bot, locked)
SAVED_VAR(/mob/living/bot, emagged)
SAVED_VAR(/mob/living/bot, light_strength)
SAVED_VAR(/mob/living/bot, ignore_list)
SAVED_VAR(/mob/living/bot, target_path)
SAVED_VAR(/mob/living/bot, wait_if_pulled)
SAVED_VAR(/mob/living/bot, will_patrol)
SAVED_VAR(/mob/living/bot, patrol_speed)
SAVED_VAR(/mob/living/bot, target_speed)
SAVED_VAR(/mob/living/bot, frustration)

SAVED_VAR(/mob/living/bot/cleanbot, screwloose)
SAVED_VAR(/mob/living/bot/cleanbot, oddbutton)
SAVED_VAR(/mob/living/bot/cleanbot, blood)

SAVED_VAR(/mob/living/bot/mulebot, load)
SAVED_VAR(/mob/living/bot/mulebot, paused)
SAVED_VAR(/mob/living/bot/mulebot, crates_only)
SAVED_VAR(/mob/living/bot/mulebot, auto_return)
SAVED_VAR(/mob/living/bot/mulebot, targetName)
SAVED_VAR(/mob/living/bot/mulebot, home)
SAVED_VAR(/mob/living/bot/mulebot, homeName)

SAVED_VAR(/mob/living/bot/farmbot, waters_trays)
SAVED_VAR(/mob/living/bot/farmbot, refills_water)
SAVED_VAR(/mob/living/bot/farmbot, uproots_weeds)
SAVED_VAR(/mob/living/bot/farmbot, replaces_nutriment)
SAVED_VAR(/mob/living/bot/farmbot, collects_produce)
SAVED_VAR(/mob/living/bot/farmbot, removes_dead)
SAVED_VAR(/mob/living/bot/farmbot, tank)

SAVED_VAR(/mob/living/carbon, life_tick)
SAVED_VAR(/mob/living/carbon, pose)
SAVED_VAR(/mob/living/carbon, bloodstr)
SAVED_VAR(/mob/living/carbon, touching)
SAVED_VAR(/mob/living/carbon, nutrition)
SAVED_VAR(/mob/living/carbon, hydration)
SAVED_VAR(/mob/living/carbon, internal)
SAVED_VAR(/mob/living/carbon, species)
SAVED_VAR(/mob/living/carbon, organs_by_tag)
SAVED_VAR(/mob/living/carbon, stasis_value)
SAVED_VAR(/mob/living/carbon, player_triggered_sleeping)
SAVED_VAR(/mob/living/carbon, chem_effects)
SAVED_VAR(/mob/living/carbon, chem_doses)
SAVED_VAR(/mob/living/carbon, default_language)

SAVED_VAR(/mob/living/carbon/alien, language)

SAVED_VAR(/mob/living/silicon, idcard)



SAVED_VAR(/mob/living/silicon/pai, ram)
SAVED_VAR(/mob/living/silicon/pai, software)
SAVED_VAR(/mob/living/silicon/pai, card)
SAVED_VAR(/mob/living/silicon/pai, chassis)
SAVED_VAR(/mob/living/silicon/pai, master)
SAVED_VAR(/mob/living/silicon/pai, master_dna)
SAVED_VAR(/mob/living/silicon/pai, pai_law0)
SAVED_VAR(/mob/living/silicon/pai, pai_laws)

SAVED_VAR(/mob/living/silicon/pai, secHUD)
SAVED_VAR(/mob/living/silicon/pai, medHUD)
SAVED_VAR(/mob/living/silicon/pai, translator_on)

SAVED_VAR(/mob/living/simple_animal/hostile, show_stat_health)
SAVED_VAR(/mob/living/simple_animal/hostile, wander)
SAVED_VAR(/mob/living/simple_animal/hostile, speed)
SAVED_VAR(/mob/living/simple_animal/hostile, friendly)
SAVED_VAR(/mob/living/simple_animal/hostile, purge)
SAVED_VAR(/mob/living/simple_animal/hostile, bleed_ticks)
SAVED_VAR(/mob/living/simple_animal/hostile, in_stasis)
SAVED_VAR(/mob/living/simple_animal/hostile, return_damage_min)
SAVED_VAR(/mob/living/simple_animal/hostile, return_damage_max)

SAVED_VAR(/mob/living/simple_animal/mushroom, seed)
SAVED_VAR(/mob/living/simple_animal/mushroom, harvest_time)

///////////////////////////////////////////////////////////////////////////////
// ITEMS
///////////////////////////////////////////////////////////////////////////////

SAVED_VAR(/obj/item/ammo_casing, BB)

SAVED_VAR(/obj/item/flashlight, on)
SAVED_VAR(/obj/item/flashlight/flare, fuel)

SAVED_VAR(/obj/item/lightreplacer, uses)

SAVED_VAR(/obj/item/taperecorder, mytape)

SAVED_VAR(/obj/item/glass_jar, contains)

SAVED_VAR(/obj/item/rig_module, holder)
SAVED_VAR(/obj/item/rig_module, charges)
SAVED_VAR(/obj/item/rig_module, active)
SAVED_VAR(/obj/item/rig_module, charge_selected)

SAVED_VAR(/obj/item/robot_parts/chest, wires)
SAVED_VAR(/obj/item/robot_parts/chest, cell)

SAVED_VAR(/obj/item/robot_parts/head, flash1)
SAVED_VAR(/obj/item/robot_parts/head, flash2)

SAVED_VAR(/obj/item/robot_parts/robot_suit, parts)
SAVED_VAR(/obj/item/robot_parts/robot_suit, created_name)

SAVED_VAR(/obj/item/robot_parts, sabotaged)
SAVED_VAR(/obj/item/robot_parts, model_info)
SAVED_VAR(/obj/item/robot_parts, bp_tag)

SAVED_VAR(/obj/item/seeds, seed_type)

SAVED_VAR(/obj/item/stack, amount)
SAVED_VAR(/obj/item/stack, stack_merge_type)
SAVED_VAR(/obj/item/stack, uses_charge)

SAVED_VAR(/obj/item/stack/material, reinf_material)

SAVED_VAR(/obj/item/underwear, gender)

SAVED_VAR(/obj/item/airlock_brace, airlock)
SAVED_VAR(/obj/item/airlock_brace, electronics)

SAVED_VAR(/obj/item/beartrap, deployed)

SAVED_VAR(/obj/item/flamethrower, secured)
SAVED_VAR(/obj/item/flamethrower, throw_amount)
SAVED_VAR(/obj/item/flamethrower, lit)
SAVED_VAR(/obj/item/flamethrower, welding_tool)
SAVED_VAR(/obj/item/flamethrower, igniter)
SAVED_VAR(/obj/item/flamethrower, tank)

SAVED_VAR(/obj/item/grenade/chem_grenade, stage)
SAVED_VAR(/obj/item/grenade/chem_grenade, path)
SAVED_VAR(/obj/item/grenade/chem_grenade, detonator)
SAVED_VAR(/obj/item/grenade/chem_grenade, beakers)

SAVED_VAR(/obj/item/grenade, det_time)

SAVED_VAR(/obj/item/cell, charge)
SAVED_VAR(/obj/item/cell/device/variable, maxcharge)

SAVED_VAR(/obj/item/blackout,  last_use)

SAVED_VAR(/obj/item/spy_monitor, radio)
SAVED_VAR(/obj/item/spy_monitor, selected_camera)
SAVED_VAR(/obj/item/spy_monitor, cameras)

SAVED_VAR(/obj/item/oxycandle, on)
SAVED_VAR(/obj/item/oxycandle, air_contents)

SAVED_VAR(/obj/input_holder, reagents)

SAVED_VAR(/obj/item/evidencebag, stored_item)

SAVED_VAR(/obj/item/forensics/sample, object)
SAVED_VAR(/obj/item/forensics/sample, evidence)


SAVED_VAR(/obj/item/key, key_data)

SAVED_VAR(/obj/item/baton, status)

SAVED_VAR(/obj/item/paper, info)
SAVED_VAR(/obj/item/paper, info_links)
SAVED_VAR(/obj/item/paper, is_crumpled)
SAVED_VAR(/obj/item/paper, rigged)
SAVED_VAR(/obj/item/paper, stamp_text)
SAVED_VAR(/obj/item/paper, last_modified_ckey)

SAVED_VAR(/obj/item/paper_bundle, pages)

SAVED_VAR(/obj/item/photo, icon)
SAVED_VAR(/obj/item/photo, scribble)
SAVED_VAR(/obj/item/photo, tiny)
SAVED_VAR(/obj/item/photo, photo_size)

SAVED_VAR(/obj/item/rcd, stored_matter)

SAVED_VAR(/obj/item/rig, hides_uniform)
SAVED_VAR(/obj/item/rig, wearer)
SAVED_VAR(/obj/item/rig, chest)
SAVED_VAR(/obj/item/rig, cell)
SAVED_VAR(/obj/item/rig, air_supply)
SAVED_VAR(/obj/item/rig, boots)
SAVED_VAR(/obj/item/rig, helmet)
SAVED_VAR(/obj/item/rig, gloves)
SAVED_VAR(/obj/item/rig, selected_module)
SAVED_VAR(/obj/item/rig, visor)
SAVED_VAR(/obj/item/rig, speech)
SAVED_VAR(/obj/item/rig, installed_modules)
SAVED_VAR(/obj/item/rig, open)
SAVED_VAR(/obj/item/rig, locked)
SAVED_VAR(/obj/item/rig, subverted)
SAVED_VAR(/obj/item/rig, interface_locked)
SAVED_VAR(/obj/item/rig, control_overridden)
SAVED_VAR(/obj/item/rig, ai_override_enabled)
SAVED_VAR(/obj/item/rig, security_check_enabled)
SAVED_VAR(/obj/item/rig, malfunctioning)
SAVED_VAR(/obj/item/rig, electrified)
SAVED_VAR(/obj/item/rig, locked_down)
SAVED_VAR(/obj/item/rig, offline)
SAVED_VAR(/obj/item/rig, airtight)

SAVED_VAR(/obj/item/stool, padding_material)

SAVED_VAR(/obj/item/weldingtool, tank)

SAVED_VAR(/obj/item/chems/weldpack, welder)

SAVED_VAR(/obj/vehicle/train/cargo/engine, key)

SAVED_VAR(/obj/vehicle/train, passenger_allowed)

SAVED_VAR(/obj/vehicle, on)
SAVED_VAR(/obj/vehicle, current_health)
SAVED_VAR(/obj/vehicle, open)
SAVED_VAR(/obj/vehicle, locked)
SAVED_VAR(/obj/vehicle, stat)
SAVED_VAR(/obj/vehicle, cell)
SAVED_VAR(/obj/vehicle, load)

SAVED_VAR(/obj/item/chems/hypospray/vial, loaded_vial)

SAVED_VAR(/obj/item/chems/hypospray/autoinjector, detail_state)
SAVED_VAR(/obj/item/chems/hypospray/autoinjector, detail_color)

SAVED_VAR(/obj/item/tankassemblyproxy, tank)
SAVED_VAR(/obj/item/tankassemblyproxy, assembly)

SAVED_VAR(/obj/item/screwdriver,  handle_color)

SAVED_VAR(/obj/item/wrench,  handle_color)

SAVED_VAR(/obj/item/duct_tape, stuck)

SAVED_VAR(/obj/item/solar_assembly, tracker)
SAVED_VAR(/obj/item/solar_assembly, glass_type)

SAVED_VAR(/obj/item/fuel_assembly, material_name)
SAVED_VAR(/obj/item/fuel_assembly, matter)
SAVED_VAR(/obj/item/fuel_assembly, percent_depleted)
SAVED_VAR(/obj/item/fuel_assembly, radioactivity)

SAVED_VAR(/obj/item/lock_construct, lock_data)

SAVED_VAR(/obj/item/passport, info)

SAVED_VAR(/obj/item/bodybag/rescue, airtank)

SAVED_VAR(/obj/item/latexballon, air_contents)

SAVED_VAR(/obj/item/clothing/accessory/badge/tags, owner_rank)
SAVED_VAR(/obj/item/clothing/accessory/badge/tags, owner_name)
SAVED_VAR(/obj/item/clothing/accessory/badge/tags, owner_branch)
SAVED_VAR(/obj/item/clothing/accessory/badge/tags, desc)

SAVED_VAR(/obj/item/flame/lighter, reagents)

///////////////////////////////////////////////////////////////////////////////
// item/clothing
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// item/assembly
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/obj/item/assembly/mousetrap, armed)

SAVED_VAR(/obj/item/assembly/prox_sensor, scanning)
SAVED_VAR(/obj/item/assembly/prox_sensor, timing)
SAVED_VAR(/obj/item/assembly/prox_sensor, time)
SAVED_VAR(/obj/item/assembly/prox_sensor, range)

SAVED_VAR(/obj/item/assembly/signaler, code)
SAVED_VAR(/obj/item/assembly/signaler, connected)
SAVED_VAR(/obj/item/assembly/signaler, deadman)

SAVED_VAR(/obj/item/assembly/timer, timing)
SAVED_VAR(/obj/item/assembly/timer, time)

SAVED_VAR(/obj/item/assembly/voice, listening)
SAVED_VAR(/obj/item/assembly/voice, recorded)

SAVED_VAR(/obj/item/assembly, secured)
SAVED_VAR(/obj/item/assembly, attached_overlays)
SAVED_VAR(/obj/item/assembly, holder)
SAVED_VAR(/obj/item/assembly, wires)

SAVED_VAR(/obj/item/assembly_holder, secured)
SAVED_VAR(/obj/item/assembly_holder, a_left)
SAVED_VAR(/obj/item/assembly_holder, a_right)
SAVED_VAR(/obj/item/assembly_holder, special_assembly)
SAVED_VAR(/obj/item/assembly_holder, master)


///////////////////////////////////////////////////////////////////////////////
// item/disk
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// item/gun
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// item/implant
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// CIRCUITS
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/obj/item/electronic_assembly, assembly_components)
SAVED_VAR(/obj/item/electronic_assembly, ckeys_allowed_to_scan)
SAVED_VAR(/obj/item/electronic_assembly, opened)
SAVED_VAR(/obj/item/electronic_assembly, battery)
SAVED_VAR(/obj/item/electronic_assembly, cell_type)
SAVED_VAR(/obj/item/electronic_assembly, ext_next_use)
SAVED_VAR(/obj/item/electronic_assembly, collw)
SAVED_VAR(/obj/item/electronic_assembly, creator)
SAVED_VAR(/obj/item/electronic_assembly, interact_page)
SAVED_VAR(/obj/item/electronic_assembly, components_per_page)
SAVED_VAR(/obj/item/electronic_assembly, detail_color)

SAVED_VAR(/obj/item/integrated_electronics/detailer, detail_color)

SAVED_VAR(/obj/item/integrated_circuit, assembly)
SAVED_VAR(/obj/item/integrated_circuit, extended_desc)
SAVED_VAR(/obj/item/integrated_circuit, inputs)
SAVED_VAR(/obj/item/integrated_circuit, outputs)
SAVED_VAR(/obj/item/integrated_circuit, activators)
SAVED_VAR(/obj/item/integrated_circuit, complexity)
SAVED_VAR(/obj/item/integrated_circuit, size)
SAVED_VAR(/obj/item/integrated_circuit, power_draw_per_use)
SAVED_VAR(/obj/item/integrated_circuit, power_draw_idle)
SAVED_VAR(/obj/item/integrated_circuit, spawn_flags)
SAVED_VAR(/obj/item/integrated_circuit, removable)
SAVED_VAR(/obj/item/integrated_circuit, displayed_name)

SAVED_VAR(/obj/item/integrated_circuit_printer, upgraded)
SAVED_VAR(/obj/item/integrated_circuit_printer, can_clone)
SAVED_VAR(/obj/item/integrated_circuit_printer, fast_clone)
SAVED_VAR(/obj/item/integrated_circuit_printer, debug)
SAVED_VAR(/obj/item/integrated_circuit_printer, current_category)
SAVED_VAR(/obj/item/integrated_circuit_printer, cloning)
SAVED_VAR(/obj/item/integrated_circuit_printer, recycling)
SAVED_VAR(/obj/item/integrated_circuit_printer, program)
SAVED_VAR(/obj/item/integrated_circuit_printer, materials)
SAVED_VAR(/obj/item/integrated_circuit_printer, metal_max)

SAVED_VAR(/obj/prefab, prefab_type)

SAVED_VAR(/obj/item/integrated_circuit/passive/power/relay, power_amount)

SAVED_VAR(/obj/item/integrated_circuit/passive/power/chemical_cell, volume)
SAVED_VAR(/obj/item/integrated_circuit/passive/power/chemical_cell, multi)

SAVED_VAR(/obj/item/integrated_circuit/filter/ref, filter_type)

SAVED_VAR(/obj/item/integrated_circuit/transfer/demultiplexer, number_of_pins)

SAVED_VAR(/obj/item/integrated_circuit/transfer/pulsedemultiplexer, number_of_pins)

SAVED_VAR(/obj/item/integrated_circuit/converter/concatenator, number_of_pins)

SAVED_VAR(/obj/item/integrated_circuit/output/access_displayer, access)

SAVED_VAR(/obj/item/integrated_circuit/input/advanced_locator_list, radius)

SAVED_VAR(/obj/item/integrated_circuit/input/advanced_locator, radius)

SAVED_VAR(/obj/item/integrated_circuit/input/signaler, code)

SAVED_VAR(/obj/item/integrated_circuit/input/signaler/advanced, command)

SAVED_VAR(/obj/item/integrated_circuit/lists/constructor, number_of_pins)

SAVED_VAR(/obj/item/integrated_circuit/lists/deconstructor, number_of_pins)

SAVED_VAR(/obj/item/integrated_circuit/manipulation/weapon_firing, installed_gun)

SAVED_VAR(/obj/item/integrated_circuit/manipulation/grenade, attached_grenade)

SAVED_VAR(/obj/item/integrated_circuit/manipulation/grabber,  max_items)

SAVED_VAR(/obj/item/integrated_circuit/manipulation/claw,  pulling)

SAVED_VAR(/obj/item/integrated_circuit/manipulation/ai, controlling)
SAVED_VAR(/obj/item/integrated_circuit/manipulation/ai, aicard)

SAVED_VAR(/obj/item/integrated_circuit/manipulation/hatchlock, lock_enabled)

SAVED_VAR(/obj/item/integrated_circuit/memory, number_of_pins)

SAVED_VAR(/obj/item/integrated_circuit/output/screen, eol)
SAVED_VAR(/obj/item/integrated_circuit/output/screen, stuff_to_display)

SAVED_VAR(/obj/item/integrated_circuit/output/light, light_toggled)
SAVED_VAR(/obj/item/integrated_circuit/output/light, light_brightness)
SAVED_VAR(/obj/item/integrated_circuit/output/light, light_rgb)

SAVED_VAR(/obj/item/integrated_circuit/output/sound, sounds)

SAVED_VAR(/obj/item/integrated_circuit/output/video_camera, camera_name)

SAVED_VAR(/obj/item/integrated_circuit/output/led, led_color)

SAVED_VAR(/obj/item/integrated_circuit/power/transmitter, amount_to_move)

SAVED_VAR(/obj/item/integrated_circuit/reagent/smoke, smoke_radius)
SAVED_VAR(/obj/item/integrated_circuit/reagent/smoke, notified)

SAVED_VAR(/obj/item/integrated_circuit/reagent/injector, direction_mode)
SAVED_VAR(/obj/item/integrated_circuit/reagent/injector, transfer_amount)
SAVED_VAR(/obj/item/integrated_circuit/reagent/injector, busy)

SAVED_VAR(/obj/item/integrated_circuit/reagent/pump,  transfer_amount)
SAVED_VAR(/obj/item/integrated_circuit/reagent/pump, direction_mode)

SAVED_VAR(/obj/item/integrated_circuit/reagent/filter,  transfer_amount)
SAVED_VAR(/obj/item/integrated_circuit/reagent/filter, direction_mode)

SAVED_VAR(/obj/item/integrated_circuit/reagent/temp,  active)
SAVED_VAR(/obj/item/integrated_circuit/reagent/temp, min_temp)
SAVED_VAR(/obj/item/integrated_circuit/reagent/temp, max_temp)
SAVED_VAR(/obj/item/integrated_circuit/reagent/temp, heating_power)
SAVED_VAR(/obj/item/integrated_circuit/reagent/temp, target_temp)
SAVED_VAR(/obj/item/integrated_circuit/reagent/temp, last_temperature)
SAVED_VAR(/obj/item/integrated_circuit/reagent/temp, mode)

SAVED_VAR(/obj/item/integrated_circuit/smart/advanced_pathfinder,  idc)

SAVED_VAR(/obj/item/integrated_circuit/time/delay,  delay)

SAVED_VAR(/obj/item/integrated_circuit/time/ticker,  delay)
SAVED_VAR(/obj/item/integrated_circuit/time/ticker, is_running)

///////////////////////////////////////////////////////////////////////////////
//Effects
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// Structures
///////////////////////////////////////////////////////////////////////////////

SAVED_VAR(/obj/structure/janitorialcart, mybag)
SAVED_VAR(/obj/structure/janitorialcart, mymop)
SAVED_VAR(/obj/structure/janitorialcart, myspray)
SAVED_VAR(/obj/structure/janitorialcart, myreplacer)
SAVED_VAR(/obj/structure/janitorialcart, signs)

SAVED_VAR(/obj/structure/lift/button, floor)

SAVED_VAR(/obj/structure/ore_box, stored_ore)

SAVED_VAR(/obj/structure/sign/poster, poster_design)
SAVED_VAR(/obj/structure/sign/poster, ruined)

SAVED_VAR(/obj/structure/table, is_flipped)
SAVED_VAR(/obj/structure/table, additional_reinf_material)
SAVED_VAR(/obj/structure/table, felted)

SAVED_VAR(/obj/structure/wall_frame, stripe_color)

SAVED_VAR(/obj/structure/window, polarized)
SAVED_VAR(/obj/structure/window, basestate)
SAVED_VAR(/obj/structure/window, reinf_basestate)

SAVED_VAR(/obj/structure/iv_drip, mode)
SAVED_VAR(/obj/structure/iv_drip, beaker)
SAVED_VAR(/obj/structure/iv_drip, attached)
SAVED_VAR(/obj/structure/iv_drip, transfer_amount)

SAVED_VAR(/obj/structure/disposalpipe/diversion_junction, active)
SAVED_VAR(/obj/structure/disposalpipe/diversion_junction, active_dir)
SAVED_VAR(/obj/structure/disposalpipe/diversion_junction, inactive_dir)
SAVED_VAR(/obj/structure/disposalpipe/diversion_junction, sortdir)
SAVED_VAR(/obj/structure/disposalpipe/diversion_junction, linked)

SAVED_VAR(/obj/structure/disposalpipe/sortjunction, sortdir)
SAVED_VAR(/obj/structure/disposalpipe/sortjunction, posdir)
SAVED_VAR(/obj/structure/disposalpipe/sortjunction, negdir)

SAVED_VAR(/obj/structure/disposalpipe/tagger, sort_tag)
SAVED_VAR(/obj/structure/disposalpipe/tagger, partial)

SAVED_VAR(/obj/structure/lift, lift)

SAVED_VAR(/obj/structure/door, lock)
SAVED_VAR(/obj/structure/door, has_window)
SAVED_VAR(/obj/structure/door, icon_base)

SAVED_VAR(/obj/structure/catwalk, hatch_open)
SAVED_VAR(/obj/structure/catwalk, plated_tile)

SAVED_VAR(/obj/structure/displaycase, destroyed)

SAVED_VAR(/obj/structure/closet/body_bag/cryobag, airtank)
SAVED_VAR(/obj/structure/closet/body_bag/cryobag, stasis_power)
SAVED_VAR(/obj/structure/closet/body_bag/cryobag, degradation_time)

///////////////////////////////////////////////////////////////////////////////
// MACHINERY
///////////////////////////////////////////////////////////////////////////////
SAVED_VAR(/obj/machinery, reagents)

SAVED_VAR(/obj/machinery/alarm, rcon_setting)
SAVED_VAR(/obj/machinery/alarm, locked)
SAVED_VAR(/obj/machinery/alarm, aidisabled)
SAVED_VAR(/obj/machinery/alarm, mode)
SAVED_VAR(/obj/machinery/alarm, target_temperature)
SAVED_VAR(/obj/machinery/alarm, regulating_temperature)
SAVED_VAR(/obj/machinery/alarm, TLV)
SAVED_VAR(/obj/machinery/alarm, oxygen_dangerlevel)
SAVED_VAR(/obj/machinery/alarm, co2_dangerlevel)
SAVED_VAR(/obj/machinery/alarm, report_danger_level)

SAVED_VAR(/obj/machinery/atmospherics/binary/passive_gate, unlocked)
SAVED_VAR(/obj/machinery/atmospherics/binary/passive_gate, target_pressure)
SAVED_VAR(/obj/machinery/atmospherics/binary/passive_gate, regulate_mode)

SAVED_VAR(/obj/machinery/atmospherics/binary/pump, target_pressure)

SAVED_VAR(/obj/machinery/atmospherics/omni/filter, set_flow_rate)

SAVED_VAR(/obj/machinery/atmospherics/omni, configuring)
SAVED_VAR(/obj/machinery/atmospherics/omni, overlays_on)
SAVED_VAR(/obj/machinery/atmospherics/omni, overlays_off)
SAVED_VAR(/obj/machinery/atmospherics/omni, tag_north)
SAVED_VAR(/obj/machinery/atmospherics/omni, tag_east)
SAVED_VAR(/obj/machinery/atmospherics/omni, tag_south)
SAVED_VAR(/obj/machinery/atmospherics/omni, tag_west)
SAVED_VAR(/obj/machinery/atmospherics/omni, ports)

SAVED_VAR(/datum/omni_port, master)
SAVED_VAR(/datum/omni_port, direction)
SAVED_VAR(/datum/omni_port, mode)
SAVED_VAR(/datum/omni_port, concentration)
SAVED_VAR(/datum/omni_port, con_lock)
SAVED_VAR(/datum/omni_port, air)
SAVED_VAR(/datum/omni_port, nodes)
SAVED_VAR(/datum/omni_port, filtering)

SAVED_VAR(/obj/machinery/atmospherics/unary/outlet_injector, injecting)
SAVED_VAR(/obj/machinery/atmospherics/unary/outlet_injector, volume_rate)

SAVED_VAR(/obj/machinery/atmospherics/unary/vent_pump, pump_direction)
SAVED_VAR(/obj/machinery/atmospherics/unary/vent_pump, external_pressure_bound)
SAVED_VAR(/obj/machinery/atmospherics/unary/vent_pump, internal_pressure_bound)
SAVED_VAR(/obj/machinery/atmospherics/unary/vent_pump, pressure_checks)
SAVED_VAR(/obj/machinery/atmospherics/unary/vent_pump, welded)

SAVED_VAR(/obj/machinery/atmospherics/unary/vent_scrubber, scrubbing)
SAVED_VAR(/obj/machinery/atmospherics/unary/vent_scrubber, welded)

SAVED_VAR(/obj/machinery/atmospherics/valve, open)

SAVED_VAR(/obj/machinery/atmospherics, initialize_directions)
SAVED_VAR(/obj/machinery/atmospherics, pipe_color)

SAVED_VAR(/obj/machinery/beehive, bee_count)
SAVED_VAR(/obj/machinery/beehive, frames)

SAVED_VAR(/obj/machinery/biogenerator, points)
SAVED_VAR(/obj/machinery/biogenerator, beaker)

SAVED_VAR(/obj/machinery/bodyscanner, occupant)

SAVED_VAR(/obj/machinery/chemical_dispenser, cartridges)
SAVED_VAR(/obj/machinery/chemical_dispenser, container)

SAVED_VAR(/obj/machinery/computer/shuttle_control, hacked)
SAVED_VAR(/obj/machinery/computer/shuttle_control, shuttle_tag)

SAVED_VAR(/obj/machinery/cryopod, occupant)

SAVED_VAR(/obj/machinery/deployable/barrier, locked)

SAVED_VAR(/obj/machinery/disposal, air_contents)
SAVED_VAR(/obj/machinery/disposal, mode)
SAVED_VAR(/obj/machinery/disposal, trunk)

SAVED_VAR(/obj/machinery/door/airlock/lift, lift)
SAVED_VAR(/obj/machinery/door/airlock/lift, floor)

SAVED_VAR(/obj/machinery/door/airlock, aiControlDisabled)
SAVED_VAR(/obj/machinery/door/airlock, welded)
SAVED_VAR(/obj/machinery/door/airlock, locked)
SAVED_VAR(/obj/machinery/door/airlock, lock_cut_state)
SAVED_VAR(/obj/machinery/door/airlock, lights)
SAVED_VAR(/obj/machinery/door/airlock, aiDisabledIdScanner)
SAVED_VAR(/obj/machinery/door/airlock, aiHacking)
SAVED_VAR(/obj/machinery/door/airlock, mineral)
SAVED_VAR(/obj/machinery/door/airlock, justzap)
SAVED_VAR(/obj/machinery/door/airlock, safe)
SAVED_VAR(/obj/machinery/door/airlock, hasShocked)
SAVED_VAR(/obj/machinery/door/airlock, secured_wires)
SAVED_VAR(/obj/machinery/door/airlock, brace)
SAVED_VAR(/obj/machinery/door/airlock, paintable)
SAVED_VAR(/obj/machinery/door/airlock, door_color)
SAVED_VAR(/obj/machinery/door/airlock, stripe_color)
SAVED_VAR(/obj/machinery/door/airlock, symbol_color)
SAVED_VAR(/obj/machinery/door/airlock, shockedby)

SAVED_VAR(/obj/machinery/door/firedoor, areas_added)
SAVED_VAR(/obj/machinery/door/firedoor, pdiff)
SAVED_VAR(/obj/machinery/door/firedoor, pdiff_alert)
SAVED_VAR(/obj/machinery/door/firedoor, blocked)
SAVED_VAR(/obj/machinery/door/firedoor, lockdown)
SAVED_VAR(/obj/machinery/door/firedoor, nextstate)

SAVED_VAR(/obj/machinery/door/window, base_state)

SAVED_VAR(/obj/machinery/door, visible)
SAVED_VAR(/obj/machinery/door, glass)
SAVED_VAR(/obj/machinery/door, max_health)
SAVED_VAR(/obj/machinery/door, close_door_at)
SAVED_VAR(/obj/machinery/door, pry_mod)
SAVED_VAR(/obj/machinery/door, block_air_zones)
SAVED_VAR(/obj/machinery/door, destroy_hits)

SAVED_VAR(/obj/machinery/embedded_controller, on)

SAVED_VAR(/obj/machinery/embedded_controller/radio/simple_docking_controller, tag_door)

SAVED_VAR(/obj/machinery/embedded_controller/radio/docking_port_multi, child_names)
SAVED_VAR(/obj/machinery/embedded_controller/radio/docking_port_multi, child_names_txt)
SAVED_VAR(/obj/machinery/embedded_controller/radio/docking_port_multi, child_tags_txt)

SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock/docking_port, display_name)

SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, cycle_to_external_air)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_exterior_door)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_interior_door)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_airpump)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_chamber_sensor)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_exterior_sensor)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_interior_sensor)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_secure)
SAVED_VAR(/obj/machinery/embedded_controller/radio/airlock, tag_air_alarm)

SAVED_VAR(/obj/machinery/light_switch, on)

SAVED_VAR(/obj/machinery/microwave, dirty)
SAVED_VAR(/obj/machinery/microwave, broken)

SAVED_VAR(/obj/machinery/material_processing/smeltery, casting)
SAVED_VAR(/obj/machinery/material_processing/smeltery, show_all_materials)
SAVED_VAR(/obj/machinery/material_processing/smeltery, show_materials)

SAVED_VAR(/obj/machinery/navbeacon, locked)
SAVED_VAR(/obj/machinery/navbeacon, location)
SAVED_VAR(/obj/machinery/navbeacon, codes)

SAVED_VAR(/obj/machinery/papershredder, shredder_bin)
SAVED_VAR(/obj/machinery/papershredder, cached_total_matter)

SAVED_VAR(/obj/machinery/photocopier, scanner_item)

SAVED_VAR(/obj/machinery/faxmachine, scanner_item)
SAVED_VAR(/obj/machinery/faxmachine, quick_dial)
SAVED_VAR(/obj/machinery/faxmachine, fax_history)

SAVED_VAR(/obj/machinery/portable_atmospherics/canister, valve_open)
SAVED_VAR(/obj/machinery/portable_atmospherics/canister, release_pressure)
SAVED_VAR(/obj/machinery/portable_atmospherics/canister, canister_color)

SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, base_name)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, waterlevel)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, nutrilevel)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, pestlevel)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, weedlevel)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, dead)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, harvest)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, age)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, sampled)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, yield_mod)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, mutation_mod)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, toxins)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, mutation_level)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, tray_light)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, closed_system)
SAVED_VAR(/obj/machinery/portable_atmospherics/hydroponics, seed)

SAVED_VAR(/obj/machinery/portable_atmospherics, air_contents)
SAVED_VAR(/obj/machinery/portable_atmospherics, holding)

SAVED_VAR(/obj/machinery/porta_turret, locked)
SAVED_VAR(/obj/machinery/porta_turret, installation)
SAVED_VAR(/obj/machinery/porta_turret, check_access)
SAVED_VAR(/obj/machinery/porta_turret, enabled)
SAVED_VAR(/obj/machinery/porta_turret, lethal)

SAVED_VAR(/obj/machinery/emitter, active)
SAVED_VAR(/obj/machinery/emitter, locked)
SAVED_VAR(/obj/machinery/emitter, powered)
SAVED_VAR(/obj/machinery/emitter, burst_shots)
SAVED_VAR(/obj/machinery/emitter, shot_number)

SAVED_VAR(/obj/machinery/port_gen, active)
SAVED_VAR(/obj/machinery/port_gen, power_output)
SAVED_VAR(/obj/machinery/port_gen/pacman, sheets)
SAVED_VAR(/obj/machinery/port_gen/pacman, operating_temperature)
SAVED_VAR(/obj/machinery/port_gen/pacman, overheating)

SAVED_VAR(/obj/machinery/power/solar, adir)

SAVED_VAR(/obj/machinery/power/solar_control, cdir)
SAVED_VAR(/obj/machinery/power/solar_control, trackrate)
SAVED_VAR(/obj/machinery/power/solar_control, targetdir)
SAVED_VAR(/obj/machinery/power/solar_control, track)

SAVED_VAR(/obj/machinery/reagentgrinder, beaker)

SAVED_VAR(/obj/machinery/chem_master, beaker)
SAVED_VAR(/obj/machinery/chem_master, loaded_pill_bottle)
SAVED_VAR(/obj/machinery/chem_master, mode)
SAVED_VAR(/obj/machinery/chem_master, useramount)
SAVED_VAR(/obj/machinery/chem_master, pillamount)
SAVED_VAR(/obj/machinery/chem_master, pillsprite)
SAVED_VAR(/obj/machinery/chem_master, bottle_label_color)
SAVED_VAR(/obj/machinery/chem_master, bottle_lid_color)

SAVED_VAR(/obj/machinery/recharger, charging)

SAVED_VAR(/obj/machinery/sleeper, occupant)
SAVED_VAR(/obj/machinery/sleeper, beaker)
SAVED_VAR(/obj/machinery/sleeper, filtering)
SAVED_VAR(/obj/machinery/sleeper, pump)
SAVED_VAR(/obj/machinery/sleeper, stasis)

SAVED_VAR(/obj/machinery/smartfridge, item_records)
SAVED_VAR(/obj/machinery/smartfridge, locked)
SAVED_VAR(/obj/machinery/smartfridge, scan_id)

SAVED_VAR(/obj/machinery/button, active)
SAVED_VAR(/obj/machinery/button, operating)
SAVED_VAR(/obj/machinery/button, state)

SAVED_VAR(/obj/machinery/button/access, command)

SAVED_VAR(/obj/machinery/atmospherics/pipe, leaking)

SAVED_VAR(/obj/machinery/disposal_switch, on)

SAVED_VAR(/obj/machinery/light, on)
SAVED_VAR(/obj/machinery/light, current_mode)
SAVED_VAR(/obj/machinery/light, light_type)
SAVED_VAR(/obj/machinery/light, lightbulb)

SAVED_VAR(/obj/machinery/power/supermatter, damage)
SAVED_VAR(/obj/machinery/power/supermatter, exploded)
SAVED_VAR(/obj/machinery/power/supermatter, power)

SAVED_VAR(/obj/machinery/kinetic_harvester, stored)
SAVED_VAR(/obj/machinery/kinetic_harvester, harvesting)
SAVED_VAR(/obj/machinery/kinetic_harvester, harvest_from)

SAVED_VAR(/obj/machinery/fusion_core, owned_field)
SAVED_VAR(/obj/machinery/fusion_core, field_strength)

SAVED_VAR(/obj/machinery/fuel_compressor, stored_material)

SAVED_VAR(/obj/machinery/fusion_fuel_injector, fuel_usage)
SAVED_VAR(/obj/machinery/fusion_fuel_injector, injecting)
SAVED_VAR(/obj/machinery/fusion_fuel_injector, cur_assembly)
SAVED_VAR(/obj/machinery/fusion_fuel_injector, injection_rate)

SAVED_VAR(/obj/machinery/atmospherics/unary/fission_core, control_rod_depth)
SAVED_VAR(/obj/machinery/atmospherics/unary/fission_core, fuel_rods)
SAVED_VAR(/obj/machinery/atmospherics/unary/fission_core, neutron_flux)
SAVED_VAR(/obj/machinery/atmospherics/unary/fission_core, neutron_energy)
SAVED_VAR(/obj/machinery/atmospherics/unary/fission_core, damage)

SAVED_VAR(/obj/machinery/compressor, gas_contained)
SAVED_VAR(/obj/machinery/compressor, capacity)
SAVED_VAR(/obj/machinery/compressor, comp_id)

SAVED_VAR(/obj/machinery/computer/turbine_computer, compressor)
SAVED_VAR(/obj/machinery/computer/turbine_computer, doors)
SAVED_VAR(/obj/machinery/computer/turbine_computer, door_status)

SAVED_VAR(/obj/machinery/emitter/gyrotron, rate)
SAVED_VAR(/obj/machinery/emitter/gyrotron, mega_energy)

SAVED_VAR(/obj/machinery/computer/ship/engines, display_state)

SAVED_VAR(/obj/machinery/computer/ship/helm, autopilot)
SAVED_VAR(/obj/machinery/computer/ship/helm, dx)
SAVED_VAR(/obj/machinery/computer/ship/helm, dy)
SAVED_VAR(/obj/machinery/computer/ship/helm, speedlimit)
SAVED_VAR(/obj/machinery/computer/ship/helm, accellimit)

SAVED_VAR(/obj/machinery/computer/ship/sensors, sensor_ref)
SAVED_VAR(/obj/machinery/computer/ship/sensors, muted)
SAVED_VAR(/obj/machinery/computer/ship/sensors, objects_in_view)
SAVED_VAR(/obj/machinery/computer/ship/sensors, contact_datums)
SAVED_VAR(/obj/machinery/computer/ship/sensors, trackers)

SAVED_VAR(/obj/machinery/computer/ship, linked)

SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, max_flow_rate)
SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, set_flow_rate)
SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, max_output_pressure)
SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, tag_north_con)
SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, tag_south_con)
SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, tag_east_con)
SAVED_VAR(/obj/machinery/atmospherics/omni/mixer, tag_west_con)

SAVED_VAR(/obj/machinery/suit_cycler, safeties)
SAVED_VAR(/obj/machinery/suit_cycler, radiation_level)
SAVED_VAR(/obj/machinery/suit_cycler, model_text)
SAVED_VAR(/obj/machinery/suit_cycler, locked)
SAVED_VAR(/obj/machinery/suit_cycler, can_repair)
SAVED_VAR(/obj/machinery/suit_cycler, electrified)
SAVED_VAR(/obj/machinery/suit_cycler, occupant)
SAVED_VAR(/obj/machinery/suit_cycler, suit)
SAVED_VAR(/obj/machinery/suit_cycler, helmet)
SAVED_VAR(/obj/machinery/suit_cycler, boots)

SAVED_VAR(/obj/machinery/computer/air_control,  pressure_setting)
SAVED_VAR(/obj/machinery/computer/air_control, input_flow_setting)
SAVED_VAR(/obj/machinery/computer/air_control, input_info)
SAVED_VAR(/obj/machinery/computer/air_control, output_info)
SAVED_VAR(/obj/machinery/computer/air_control, sensor_info)
SAVED_VAR(/obj/machinery/computer/air_control, input_tag)
SAVED_VAR(/obj/machinery/computer/air_control, output_tag)
SAVED_VAR(/obj/machinery/computer/air_control, sensor_tag)
SAVED_VAR(/obj/machinery/computer/air_control, sensor_name)

SAVED_VAR(/obj/machinery/computer/air_control, out_pressure_mode)
SAVED_VAR(/obj/machinery/computer/air_control, automation)
SAVED_VAR(/obj/machinery/computer/air_control, data)

SAVED_VAR(/obj/machinery/network, overheated)
SAVED_VAR(/obj/machinery/network, initial_network_id)
SAVED_VAR(/obj/machinery/network, initial_network_key)

SAVED_VAR(/obj/machinery/network/mainframe,  initial_roles)

SAVED_VAR(/obj/machinery/tracking_beacon,  beacon)

SAVED_VAR(/obj/machinery/mining/drill, generated_ore)
SAVED_VAR(/obj/machinery/mining/drill, active)
SAVED_VAR(/obj/machinery/mining/drill, harvest_speed)
SAVED_VAR(/obj/machinery/mining/drill, capacity)
SAVED_VAR(/obj/machinery/mining/drill, supports)
SAVED_VAR(/obj/machinery/mining/drill, supported)

SAVED_VAR(/obj/machinery/rad_collector, melted)
SAVED_VAR(/obj/machinery/rad_collector, active)
SAVED_VAR(/obj/machinery/rad_collector, locked)
SAVED_VAR(/obj/machinery/rad_collector, last_rads)
SAVED_VAR(/obj/machinery/rad_collector, loaded_tank)

SAVED_VAR(/obj/machinery/docking_beacon, display_name)
SAVED_VAR(/obj/machinery/docking_beacon, permitted_shuttles)
SAVED_VAR(/obj/machinery/docking_beacon, locked)
SAVED_VAR(/obj/machinery/docking_beacon, docking_by_codes)
SAVED_VAR(/obj/machinery/docking_beacon, docking_codes)
SAVED_VAR(/obj/machinery/docking_beacon, docking_width)
SAVED_VAR(/obj/machinery/docking_beacon, docking_height)
SAVED_VAR(/obj/machinery/docking_beacon, projecting)
SAVED_VAR(/obj/machinery/docking_beacon, construction_mode)

SAVED_VAR(/obj/machinery/material_processing/extractor, dispense_amount)
SAVED_VAR(/obj/machinery/material_processing/extractor, output_container)
SAVED_VAR(/obj/machinery/material_processing/extractor, gas_contents)

SAVED_VAR(/obj/machinery/destructive_analyzer, loaded_item)

SAVED_VAR(/obj/machinery/atmospherics/unary/heater, set_temperature)
SAVED_VAR(/obj/machinery/atmospherics/unary/heater, power_setting)

SAVED_VAR(/obj/machinery/atmospherics/unary/freezer, set_temperature)
SAVED_VAR(/obj/machinery/atmospherics/unary/freezer, power_setting)

SAVED_VAR(/obj/machinery/forensic, sample)

SAVED_VAR(/obj/machinery/botany, seed)
SAVED_VAR(/obj/machinery/botany, loaded_disk)

SAVED_VAR(/obj/machinery/botany/extractor, genetics)
SAVED_VAR(/obj/machinery/botany/extractor, degradation)

SAVED_VAR(/obj/machinery/seed_storage, piles)