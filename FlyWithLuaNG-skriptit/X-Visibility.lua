--X-Visibility Plugin
--For X-Plane 11.25+
--Developed by: ChinNoobonic & SNowblind7
xvis_version = "1.0.3"
xvis_build = "2019-03-12"

--PLUGIN OPTIONS
xvis_plugin_on = true --enable plugin
xvis_debug_info = false --show debug info
xvis_atmoTop_visibility = 30480 --elevation to apply the max visibility, default is 30480 m
xvis_minFog_value = 0.3 --minimum fog value. Recommending values 0.0-1.0, default is 0.6
xvis_atmoTop_Fog = 1.5 --fog value after passing atmoTop_visibility
xvis_highAltFogMult = 0.75 --reduce to 0.5 or 0.25 if you feel the haze at higher altitude is too strong, default is 0.75

-------------------------------------------------------------------------------------------------------
--INTERNAL VARIABLES (Don´t change!)
dataref("gnd_imm_max","sim/private/controls/skyc/gnd_imm_max", "writable")
dataref("lit_imm_max","sim/private/controls/skyc/lit_imm_max", "writable")
dataref("lit_imm_min","sim/private/controls/skyc/lit_imm_min", "writable")
dataref("sky_imm_max","sim/private/controls/skyc/sky_imm_max", "writable")
dataref("sky_imm_min","sim/private/controls/skyc/sky_imm_min", "writable")
dataref("cld_imm_max","sim/private/controls/skyc/cld_imm_max", "writable")
dataref("cld_imm_min","sim/private/controls/skyc/cld_imm_min", "writable")
dataref("visibility_reported_m","sim/weather/visibility_reported_m", "readonly")
dataref("realFrame_time","sim/operation/misc/frame_rate_period","readonly")
dataref("view_y_meters", "sim/graphics/view/view_y", "readonly", 0)
dataref("fog_be_gone", "sim/private/controls/fog/fog_be_gone", "writable")
dataref("vis_graphical","sim/private/stats/skyc/fog/far_fog_cld", "readonly")

gnd_imm_max = 20
cld_imm_max = -1
cld_imm_min = 0
lit_imm_max = 1
lit_imm_min = 0
local fog_threshold = 1
-------------------------------------------------------------------------------------------------------

function change_visbility()	
	if xvis_plugin_on then
	
		local fog_Ratio = (vis_graphical/visibility_reported_m) * xvis_highAltFogMult
		
		if xvis_minFog_value > fog_threshold then
			fog_threshold = xvis_minFog_value
		end	
		
		if visibility_reported_m >= 9000 then
			sky_imm_max = -1
			sky_imm_min = 0
		else
			sky_imm_max = 20
			sky_imm_min = -2
		end
	
		if fog_Ratio > fog_threshold+0.1 and view_y_meters < xvis_atmoTop_visibility then
			if fog_be_gone <= fog_Ratio-0.1 then
				fog_be_gone = fog_be_gone + (realFrame_time/2) * fog_Ratio
			else
				fog_be_gone = fog_Ratio
			end
		elseif math.floor(view_y_meters+.5) >= xvis_atmoTop_visibility then
			if fog_be_gone >= xvis_atmoTop_Fog+0.1 then		
				fog_be_gone = fog_be_gone - realFrame_time * fog_be_gone
			else
				fog_be_gone = xvis_atmoTop_Fog
			end
		else
			if fog_be_gone >= xvis_minFog_value+0.1 then
				fog_be_gone = fog_be_gone - realFrame_time * fog_be_gone
			else
				fog_be_gone = xvis_minFog_value
			end
		end	
	
	end
		
end

function draw_debug()	
	local infoBox_x = 40
	local infoBox_y = 600
	local line_pos = 0
	graphics.set_color( 1, 1, 0)

	line_pos = line_pos-12
	draw_string_Helvetica_12( infoBox_x, infoBox_y+line_pos, "reported_vis:" .. visibility_reported_m )
	line_pos = line_pos-12
	draw_string_Helvetica_12( infoBox_x, infoBox_y+line_pos, "calculated_vis:" .. vis_graphical )
	line_pos = line_pos-12
	draw_string_Helvetica_12( infoBox_x, infoBox_y+line_pos, "fog_be_gone:" .. fog_be_gone )
	line_pos = line_pos-12
	draw_string_Helvetica_12( infoBox_x, infoBox_y+line_pos, "view_y_meters:" .. view_y_meters )	
end

if xvis_debug_info then	
	do_every_draw("draw_debug()")
end

do_every_frame("change_visbility()")
