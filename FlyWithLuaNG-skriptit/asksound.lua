alpharef = XPLMFindDataRef("sim/flightmodel/position/alpha")
betaref = XPLMFindDataRef("sim/flightmodel/position/beta")
tasref = XPLMFindDataRef("sim/flightmodel/position/true_airspeed")

alphasound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/airflow_stall.wav")
betasound = load_WAV_file( SCRIPT_DIRECTORY .. "sounds/airflow.wav")

let_sound_loop( alphasound, true )
set_sound_pitch( alphasound, 0.5 )

let_sound_loop( betasound, true )
set_sound_pitch( betasound, 0.3 )

-- Mute until start
set_sound_gain( alphasound, 0.001 )
set_sound_gain( betasound, 0.001 )

play_sound( alphasound )
play_sound( betasound )

function update_sounds()
    local alpha = XPLMGetDataf(alpharef) + 2.5
    local beta = XPLMGetDataf(betaref)
    local tas = XPLMGetDataf(tasref)
    tas = (math.max(tas, 20) - 20)
    local alphavolume = 0.005 * tas * (math.abs(alpha) / 2)
    local betavolume = 0.01 * tas * (math.abs(beta) / 4 + 1)
    alphavolume = math.max(math.min(alphavolume, 1), 0.001)
    betavolume = math.max(math.min(betavolume, 1), 0.001)
    -- draw_string(40,40, "volume" ..  betavolume)
    set_sound_gain( alphasound, alphavolume )
    set_sound_gain( betasound, betavolume )
end

do_every_draw("update_sounds()")
