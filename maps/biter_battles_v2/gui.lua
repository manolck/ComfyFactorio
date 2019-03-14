local event = require 'utils.event' 

local food_names = {
	["automation-science-pack"] = 	"automation science",
	["logistic-science-pack"] = 	"logistic science",
	["military-science-pack"] =		"military science",
	["chemical-science-pack"] = 	"chemical science",
	["production-science-pack"] =	"production science",
	["utility-science-pack"] =		"utility science",
	["space-science-pack"] = 		"space science"
}

local food_values = {
	["automation-science-pack"] =	100,
	["logistic-science-pack"] =			292,
	["military-science-pack"] =			1225,
	["chemical-science-pack"] = 		2392,
	["production-science-pack"] =	8000,
	["utility-science-pack"] =			13875,
	["space-science-pack"] = 			42000
}

local function create_sprite_button(player)
	if player.gui.top["bb_toggle_button"] then return end
	local button = player.gui.top.add { name = "bb_toggle_button", type = "sprite-button", sprite = "entity/behemoth-spitter" }
	button.style.font = "default-bold"
	button.style.minimal_height = 38
	button.style.minimal_width = 38
	button.style.top_padding = 2
	button.style.left_padding = 4
	button.style.right_padding = 4
	button.style.bottom_padding = 2	
end

local function create_first_join_gui(player)
	if not global.game_lobby_timeout then global.game_lobby_timeout = 5999940 end
	if global.game_lobby_timeout - game.tick < 0 then global.game_lobby_active = false end
	local frame = player.gui.left.add { type = "frame", name = "bb_main_gui", direction = "vertical" }
	local b = frame.add{ type = "label", caption = "Defend your team´s rocket silo!" }
	b.style.font = "default-bold"
	b.style.font_color = { r=0.98, g=0.66, b=0.22}
	local b = frame.add  { type = "label", caption = "Feed the enemy team´s biters to gain advantage!" }
	b.style.font = "default-bold"
	b.style.font_color = { r=0.98, g=0.66, b=0.22}
	frame.add  { type = "label", caption = "-----------------------------------------------------------"}
	local c = "JOIN NORTH"		
	local font_color =  {r = 0.55, g = 0.55, b = 0.99}
	if global.game_lobby_active then
		font_color = { r=0.7, g=0.7, b=0.7}
		c = c .. " (waiting for players...  "
		c = c .. math.ceil((global.game_lobby_timeout - game.tick)/60)
		c = c .. ")"										
	end		
	local t = frame.add  { type = "table", column_count = 4 }	
	for _, p in pairs(game.forces.north.connected_players) do			
		local color = {}
		color = p.color
		color.r = color.r * 0.6 + 0.4
		color.g = color.g * 0.6 + 0.4
		color.b = color.b * 0.6 + 0.4
		color.a = 1
		local l = t.add  { type = "label", caption = p.name }
		l.style.font_color = color
	end		
	local b = frame.add  { type = "sprite-button", name = "join_north_button", caption = c }
	b.style.font = "default-large-bold"
	b.style.font_color = font_color
	b.style.minimal_width = 350	
	frame.add  { type = "label", caption = "-----------------------------------------------------------"}
	local c = "JOIN SOUTH"		
	local font_color = {r = 0.99, g = 0.33, b = 0.33}
	if global.game_lobby_active then
		font_color = { r=0.7, g=0.7, b=0.7}
		c = c .. " (waiting for players...  "
		c = c .. math.ceil((global.game_lobby_timeout - game.tick)/60)
		c = c .. ")"										
	end		
	local t = frame.add  { type = "table", column_count = 4 }	
	for _, p in pairs(game.forces.south.connected_players) do
		local color = {}
		color = p.color
		color.r = color.r * 0.6 + 0.4
		color.g = color.g * 0.6 + 0.4
		color.b = color.b * 0.6 + 0.4
		color.a = 1
		local l = t.add  { type = "label", caption = p.name }
		l.style.font_color = color
	end		
	local b = frame.add  { type = "sprite-button", name = "join_south_button", caption = c }
	b.style.font = "default-large-bold"
	b.style.font_color = font_color
	b.style.minimal_width = 350
end

local function create_main_gui(player)
	if player.gui.left["bb_main_gui"] then player.gui.left["bb_main_gui"].destroy() end
	
	if player.force.name == "player" then create_first_join_gui(player) return end
		
	local frame = player.gui.left.add { type = "frame", name = "bb_main_gui", direction = "vertical" }

	if player.force.name ~= "spectator" then			
		frame.add { type = "table", name = "biter_battle_table", column_count = 4 }
		local t = frame.biter_battle_table
		local foods = {"automation-science-pack","logistic-science-pack","military-science-pack","chemical-science-pack","production-science-pack","utility-science-pack","space-science-pack","raw-fish"}
		local food_tooltips = {"1 Mutagen factor","3 Mutagen factor", "12 Mutagen factor", "24 Mutagen factor", "80 Mutagen factor", "138 Mutagen factor", "420 Mutagen factor", "Send spy"}
		local x = 1
		for _, f in pairs(foods) do
			local s = t.add { type = "sprite-button", name = f, sprite = "item/" .. f }
			s.tooltip = {"",food_tooltips[x]}
			x = x + 1
		end
	end	
	
	local t = frame.add { type = "table", column_count = 3 }	
	local l = t.add  { type = "label", caption = "Team North"}
	l.style.font = "default-bold"
	l.style.font_color = {r = 0.55, g = 0.55, b = 0.99}
	local l = t.add  { type = "label", caption = "  -  "}
	local l = t.add  { type = "label", caption = #game.forces["north"].connected_players .. " Players "}
	l.style.font_color = { r=0.22, g=0.88, b=0.22}
	
			
	if global.bb_view_players[player.name] == true then
		local t = frame.add  { type = "table", column_count = 4 }	
		for _, p in pairs(game.forces.north.connected_players) do
			local color = {}
			color = p.color
			color.r = color.r * 0.6 + 0.4
			color.g = color.g * 0.6 + 0.4
			color.b = color.b * 0.6 + 0.4
			color.a = 1
			local l = t.add  { type = "label", caption = p.name }
			l.style.font_color = color
		end
	end

	local t = frame.add { type = "table", column_count = 4 }			
	local l = t.add  { type = "label", caption = "Nerf: "}
	l.style.minimal_width = 25
	l.tooltip = "Damage nerf of the team."
	local l = t.add  { type = "label", caption = "NERF "}
	l.style.minimal_width = 40
	l.style.font_color = {r = 0.66, g = 0.66, b = 0.99}
	l.style.font = "default-bold"		
	local l = t.add  { type = "label", caption = " Biter Rage: "}
	l.style.minimal_width = 25
	l.tooltip = "Increases damage and the amount of angry biters."
	local l = t.add  { type = "label", caption = "RAGE"}	
	l.style.font_color = {r = 0.66, g = 0.66, b = 0.99}
	l.style.font = "default-bold"
	l.style.minimal_width = 25	 
	frame.add  { type = "label", caption = "--------------------------"}						
	local t = frame.add { type = "table", column_count = 3 }	
	local l = t.add  { type = "label", caption = "Team South"}
	l.style.font = "default-bold"
	l.style.font_color = {r = 0.99, g = 0.33, b = 0.33}
	local l = t.add  { type = "label", caption = "  -  "}
	local l = t.add  { type = "label", caption = #game.forces["south"].connected_players .. " Players "}
	l.style.font_color = { r=0.22, g=0.88, b=0.22}
	
			
	if global.bb_view_players[player.name] == true then
		local t = frame.add  { type = "table", column_count = 4 }	
		for _, p in pairs(game.forces.south.connected_players) do
			local color = {}
			color = p.color
			color.r = color.r * 0.6 + 0.4
			color.g = color.g * 0.6 + 0.4
			color.b = color.b * 0.6 + 0.4
			color.a = 1
			local l = t.add  { type = "label", caption = p.name }
			l.style.font_color = color
		end		
	end
	
	local t = frame.add { type = "table", column_count = 4 }			
	local l = t.add  { type = "label", caption = "Nerf: "}
	l.tooltip = "Damage nerf of the team."
	l.style.minimal_width = 25
	local l = t.add  { type = "label", caption = "NERF"}
	l.style.minimal_width = 40
	l.style.font_color = {r = 0.99, g = 0.44, b = 0.44}
	l.style.font = "default-bold"		
	local l = t.add  { type = "label", caption = " Biter Rage: "}
	l.style.minimal_width = 25
	l.tooltip = "Increases damage and the amount of angry biters."
	local l = t.add  { type = "label", caption = "RAGE"}	
	l.style.font_color = {r = 0.99, g = 0.44, b = 0.44}
	l.style.font = "default-bold"
	l.style.minimal_width = 25
	
	local t = frame.add  { type = "table", column_count = 2 }
	if player.force.name == "spectator" then
		local b = t.add  { type = "sprite-button", name = "bb_leave_spectate", caption = "Join Team" }
	else
		local b = t.add  { type = "sprite-button", name = "bb_spectate", caption = "Spectate" }
	end
	
	if global.bb_view_players[player.name] == true then
		local b = t.add  { type = "sprite-button", name = "bb_hide_players", caption = "Playerlist" }
	else
		local b = t.add  { type = "sprite-button", name = "bb_view_players", caption = "Playerlist" }						
	end		
	for _, b in pairs(t.children) do
		b.style.font = "default-bold"
		b.style.font_color = { r=0.98, g=0.66, b=0.22}
		b.style.top_padding = 1
		b.style.left_padding = 1
		b.style.right_padding = 1
		b.style.bottom_padding = 1
		b.style.maximal_height = 30
		b.style.minimal_width = 86
	end
end

local function refresh_gui()
	for _, player in pairs(game.connected_players) do
		if player.gui.left["bb_main_gui"] then
			player.gui.left["bb_main_gui"].destroy()
			create_main_gui(player)					
		end
	end
end

local function join_team(player, force_name)
	if not global.chosen_team then global.chosen_team = {} end
	local surface = player.surface
	
	if global.chosen_team[player.name] then
		local p = surface.find_non_colliding_position("player", game.forces[global.chosen_team[player.name]].get_spawn_position(surface), 3, 1)
		player.teleport(p, surface)	
		player.force = game.forces[force_name]
		local p = game.permissions.get_group("Default")	
		p.add_player(player.name)
		game.print("Team " .. player.force.name .. " player " .. player.name .. " is no longer spectating.", {r=0.98, g=0.66, b=0.22})
		return
	end
	
	local enemy_team = "south"
	if force_name == "south" then enemy_team = "north" end
		
	if #game.forces[force_name].connected_players > #game.forces[enemy_team].connected_players then
		player.print("Team " .. force_name .. " has too many players currently.", {r=0.98, g=0.66, b=0.22})
	else
		player.teleport(surface.find_non_colliding_position("player", game.forces[force_name].get_spawn_position(surface), 3, 1))
		player.force = game.forces[force_name]					
		game.print(player.name .. " has joined team " .. player.force.name .. "!", {r=0.98, g=0.66, b=0.22})
		local i = player.get_inventory(defines.inventory.player_main)
		player.insert {name = 'pistol', count = 1}
		player.insert {name = 'raw-fish', count = 3}
		player.insert {name = 'firearm-magazine', count = 16}		
		player.insert {name = 'iron-gear-wheel', count = 4}
		player.insert {name = 'iron-plate', count = 8}
		global.chosen_team[player.name] = force_name					
	end							
end

local function join_gui_click(name, player)
	local team = {
		["join_north_button"] = "north",
		["join_south_button"] = "south"
	}
	
	if global.game_lobby_active then
		if player.admin then
			join_team(player, team[name])
			game.print("Lobby disabled, admin override.", { r=0.98, g=0.66, b=0.22})
			global.game_lobby_active = false
			return
		end
		player.print("Waiting for more players to join the game.", { r=0.98, g=0.66, b=0.22}) 
		return
	end
	join_team(player, team[name])
end

local function on_gui_click(event)
	if not event.element then return end
	if not event.element.valid then return end
	local player = game.players[event.player_index]
	local name = event.element.name
	if name == "bb_toggle_button" then
		if player.gui.left["bb_main_gui"] then
			player.gui.left["bb_main_gui"].destroy()
		else
			create_main_gui(player)
		end
		return
	end
	
	if player.force.name == "player" then join_gui_click(name, player) return end
	
	--if food_names[name] then feed_the_biters(player, name) return end
	
	if name == "bb_spectate" then
		if player.position.y < 100 and player.position.y > -100 and player.position.x < 100 and player.position.x > -100 then
			--join_team(player, "spectator")
		else
			player.print("You are too far away from spawn to spectate.",{ r=0.98, g=0.66, b=0.22})
		end
	end		
end

local function on_player_joined_game(event)
	local player = game.players[event.player_index]
	
	if not global.bb_view_players then global.bb_view_players = {} end
	global.bb_view_players[player.name] = false
	
	create_sprite_button(player)
	if player.online_time ~= 0 then return end
	create_main_gui(player)
end

event.add(defines.events.on_gui_click, on_gui_click)
event.add(defines.events.on_player_joined_game, on_player_joined_game)

return refresh_gui