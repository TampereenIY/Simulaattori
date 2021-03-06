
-- THIS SCRIPT IS HERE TO CUSTOMIZE SOME BASIC SYSTEMS OF THE ASK21:
-- THE ASK21 WILL ALWAYS START WITH BRAKES ON AND SPOILERS DEPLOYED
-- BECAUSE BRAKES AND SPOILERS ARE LINKED TOGETHER



----------------------------------- LOCATE DATAREFS OR COMMANDS -----------------------------------
startup_running = find_dataref("sim/operation/prefs/startup_running")
battery_on = find_dataref("sim/cockpit2/electrical/battery_on[0]")
avionics_power_on = find_dataref("sim/cockpit2/switches/avionics_power_on")
speedbrake_ratio = find_dataref("sim/cockpit2/controls/speedbrake_ratio")
left_brake_ratio = find_dataref("sim/cockpit2/controls/left_brake_ratio")
parking_brake_ratio = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
radio_altimeter_height_ft_pilot = find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")

speedbrake_deploy_ratio = find_dataref("sim/flightmodel2/controls/speedbrake_ratio")


actual_parking_brake_ratio = 0
actual_speedbrake_ratio = 0

ready_for_start = 0

--------------------------------- DO THIS EACH FLIGHT START ---------------------------------
function flight_start()
        ready_for_start = 0
	if startup_running == 1 then
		battery_on = 1
		avionics_power_on = 1
		parking_brake_ratio = 1
		speedbrake_ratio = 1
		left_brake_ratio = 0
	else
		battery_on = 0
		avionics_power_on = 0
		parking_brake_ratio = 1
		speedbrake_ratio = 1
		left_brake_ratio = 0
	end
	-- IF START IS NOT ON THE GROUND THEN SPOILERS AND BRAKES OFF
	if radio_altimeter_height_ft_pilot > 10 then
		parking_brake_ratio = 0
		speedbrake_ratio = 0
		left_brake_ratio = 0
               ready_for_start = 1
	end
end



--------------------------------- REGULAR RUNTIME ---------------------------------

function before_physics()
        if speedbrake_ratio < 0.05 then
                speedbrake_ratio = 0
                speedbrake_deploy_ratio = 0
        else
                speedbrake_deploy_ratio = speedbrake_ratio * 1.065
        end
end

function after_physics()
        if ready_for_start == 1 then
        	parking_brake_ratio = left_brake_ratio
        else
        	parking_brake_ratio = 1
        end
        if left_brake_ratio > 0.1 then
               ready_for_start = 1
        end
end

--[[
function after_physics()

	-- PARK BRAKE RATIO AND SPOILERS RATIO ARE LINKED TOGETHER
	-- THIS MAKE THE USER CAN BRAKE THE GLIDER PULLING THE SPOILERS LEVER
	-- LIKE IN THE REAL ONE

	if actual_parking_brake_ratio ~= parking_brake_ratio then
		speedbrake_ratio = parking_brake_ratio
	end

	if actual_speedbrake_ratio ~= speedbrake_ratio then
		parking_brake_ratio = speedbrake_ratio
	end

	actual_parking_brake_ratio = parking_brake_ratio
	actual_speedbrake_ratio = speedbrake_ratio

end
--]]
