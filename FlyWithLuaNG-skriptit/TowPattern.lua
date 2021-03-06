-- FlyWithLua Tow pattern Script for TIY simulator
-- For Tows in Jämi Airport
-- Kari Virtanen 3.3.2021

dataref("glider_agl", "sim/flightmodel/position/y_agl", "readonly")
dataref("glider_heading", "sim/flightmodel/position/true_psi", "readonly")
dataref("brk_ratio", "sim/cockpit2/controls/parking_brake_ratio", "readonly")
dataref("flight_time", "sim/time/total_flight_time_sec", "readonly")
dataref("glider_latitude", "sim/flightmodel/position/latitude", "readonly")
dataref("glider_longitude", "sim/flightmodel/position/longitude", "readonly")

tow_start_09_sound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/HD09.wav")
tow_start_15_sound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/HD15.wav")
tow_start_27_sound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/HD27.wav")
tow_start_33_sound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/HD33.wav")

-- set_sound_gain(tow_start_27_sound, 0.5 )  -- näillä voi muuttaa soundia
-- set_sound_pitch(tow_start_27_sound, 0.9)

leg = 0
leg_time = 0
roll_leg = 0
roll_time = 0
jami_ground = 0
tow_released = 0
first_turn = 0  		-- 0=left 1=right
math.randomseed(os.time())

if glider_agl < 20 and glider_latitude < 61.9 and glider_latitude > 61.6 and glider_longitude < 23 and  glider_longitude > 22.5  then 
  jami_ground = 1    -- Checks if we are on the ground arond Jämi airfield
end

function tow_start()
if  jami_ground == 1 and brk_ratio < 0.1  then 

	if  glider_heading > 60 and glider_heading < 120  then 
		play_sound(tow_start_09_sound)	 
	end

	if  glider_heading > 120 and glider_heading < 180  then 
		play_sound(tow_start_15_sound)	 
	end
	

	if  glider_heading > 240 and glider_heading < 300  then 
		play_sound(tow_start_27_sound)
		first_turn = 1
	end

	if  glider_heading > 300 and glider_heading < 360  then 
		play_sound(tow_start_33_sound)	 
	end

 	jami_ground = 0
  end
end

function towleg()
  if leg == 0 and glider_agl > 15 then
     	if first_turn == 0 then
		leg = 2
	else 	command_once("sim/flight_controls/glider_tow_right")
        	leg_time = flight_time + math.random(5,10)
		leg = 1
	end
  elseif leg == 1 and  flight_time > leg_time then
	command_once("sim/flight_controls/glider_tow_straight")
        leg_time = flight_time + math.random(5,10)
	leg = 2
  elseif leg == 2 and  flight_time > leg_time then
	command_once("sim/flight_controls/glider_tow_left")
	leg_time = flight_time + math.random(40,70)
	leg = 3
  elseif leg == 3 and  flight_time > leg_time then
	command_once("sim/flight_controls/glider_tow_straight")
        leg_time = flight_time + math.random(5,10)
	leg = 4
  elseif leg == 4 and flight_time > leg_time then
	command_once("sim/flight_controls/glider_tow_right")
        leg_time = flight_time + math.random(10,15)
	leg = 5
  elseif leg == 5 and flight_time > leg_time then
	command_once("sim/flight_controls/glider_tow_left")
	leg_time = flight_time + math.random(10,30)
	leg = 3
  end
end

do_often("tow_start()")
do_often("towleg()")
