audio_ref = find_dataref("sim/cockpit/switches/tot_ener_audio")

function audio_on(command, phase)
  audio_ref = 1
end

function audio_off(command, phase)
  audio_ref = 0
end

create_command("Audio on", "Turn total energy audio on", audio_on)
create_command("Audio off", "Turn total energy audio off", audio_off)

