
-- OKAY, WE HAVE TWO VARIOMETERS IN THE GLIDER AND BOTH ARE COMPENSATED VARIO (TOTAL ENERGY):
-- ONE ELECTRIC (WITH HIS AUDIBLE BEEP) AND ONE MECHANIC.

-- NOW WE HAVE ONLY ONE TOTAL ENERGY DATAREF FROM AUSTIN'S CODE, SO HAVING TWO INSTRUMENT DRIVEN BY THE SAME DATAREF LOOKS WEIRD.
-- SO I'M WRITING HERE A CUSTOM ONE FOR THE MECHANICAL, LETTING THE AUSTIN'S ONE DRIVING ONLY THE ELECTRICAL.

-- WHAT I'M DOING IS SIMPLY TAKE THE AUSTIN'S DATAREF AND MAKE IT A BIT MORE SENSITIVE TO SPEED ACCELERATIONS:
-- IT WILL LOOKS LIKE WE HAVE TWO SEPARATE INSTRUMENTS DRIVEN BY TWO SEPARATE SYSTEMS.



----------------------------------- LOCATE AND CREATE DATAREFS OR COMMANDS -----------------------------------
acceleration_kts_sec = find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")
total_energy_fpm = find_dataref("sim/cockpit2/gauges/indicators/total_energy_fpm")
-- vvi_fpm = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")

vvi_ms_compensated = create_dataref("laminar/ask21/vvi_ms_compensated","number") -- the compensated vario in meter/sec



--------------------------------- REGULAR RUNTIME ---------------------------------
function after_physics()

		-- NOT USED:
		-- ((TOTALENERGY IN M/S) + (A REDUCED FACTOR OF THE ACCEL/DECEL VECTOR)) + (UNCOMPENSATED VVI IN M/S) / 2
		-- SO THIS IS A MEDIUM IN M/S FROM A COMPENSATED VARIO AND THE UNCOMPENSATED VARIO
		-- vvi_ms_compensated = ((total_energy_fpm * 0.00508) + (acceleration_kts_sec * 0.25)) + (vvi_fpm * 0.00508) / 2

		-- CURRENTLY IN USE:
		-- (TOTALENERGY IN M/S) + (A REDUCED FACTOR OF THE ACCEL/DECEL VECTOR)
		vvi_ms_compensated = (total_energy_fpm * 0.00508) + (acceleration_kts_sec * 0.25)

end