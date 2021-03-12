alpharef = XPLMFindDataRef("sim/flightmodel/position/alpha")
betaref = XPLMFindDataRef("sim/flightmodel/position/beta")
tasref = XPLMFindDataRef("sim/flightmodel/position/true_airspeed")
brakeref = XPLMFindDataRef("sim/cockpit2/controls/speedbrake_ratio")
pauseref = XPLMFindDataRef("sim/time/paused")

alphasound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/airflow_stall.wav")
betasound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/airflow.wav")
brakesound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/airflow.wav")
brake_bang_sound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/brake_bang.wav")

let_sound_loop( alphasound, true )
set_sound_pitch( alphasound, 0.5 )

let_sound_loop( betasound, true )
set_sound_pitch( betasound, 0.3 )

let_sound_loop( brakesound, true )
set_sound_pitch( brakesound, 0.1 )

-- Mute until start
set_sound_gain( alphasound, 0.001 )
set_sound_gain( betasound, 0.001 )
set_sound_gain( brakesound, 0.001 )

play_sound( alphasound )
play_sound( betasound )
play_sound( brakesound )

brakes_locked = 0

function update_sounds()
    local alpha = XPLMGetDataf(alpharef) + 2.5
    local beta = XPLMGetDataf(betaref)
    local tas = XPLMGetDataf(tasref)
    local brake = XPLMGetDataf(brakeref)


    tas = (math.max(tas, 20) - 20)
    local alphavolume = 0.008 * tas * (math.abs(alpha) / 2)
    local betavolume = 0.005 * tas * (math.abs(beta) / 4 + 1)
    local brakevolume = 0.1 * tas * brake

    if brakes_locked == 0 then
        brakevolume = brakevolume + 0.02 * tas 
    end

    alphavolume = math.max(math.min(alphavolume, 1), 0.001)
    betavolume = math.max(math.min(betavolume, 1), 0.001)
    brakevolume = math.max(math.min(brakevolume, 1), 0.001)
    -- draw_string(40,40, "volume" ..  alphavolume)

    if XPLMGetDatai(pauseref) == 1 then
        alphavolume = 0.001
        betavolume = 0.001
        brakevolume = 0.001
    end

    set_sound_gain( alphasound, alphavolume )
    set_sound_gain( betasound, betavolume )
    set_sound_gain( brakesound, brakevolume )
    
    if brakes_locked == 0 and brake < 0.01 then
        set_sound_pitch( brake_bang_sound, 1 )
        play_sound(brake_bang_sound)
        brakes_locked = 1
    end
    if brakes_locked == 1 and brake > 0.015 then
        set_sound_pitch( brake_bang_sound, 1.3 )
        play_sound(brake_bang_sound)
        brakes_locked = 0
    end
end

do_every_draw("update_sounds()")
