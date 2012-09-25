--[[

Node Owner for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-node_owner
License: GPLv3

]]--


-- override minetest.item_place_node
local old_item_place_node = minetest.item_place_node
function minetest.item_place_node(itemstack, placer, pointed_thing)
    local player = placer:get_player_name()
	local base_node = minetest.env:get_meta(pointed_thing.under)
	local owner = base_node:get_string("owner")
	
	-- do not allow placing onto other players nodes
    if owner ~= player and owner ~= '' then
		minetest.chat_send_player(player, "You can not place nodes here because it is owned by "..owner..".")
		return itemstack
    end
	
	-- place the node
	local output = old_item_place_node(itemstack, placer, pointed_thing)
	
	-- set the owner
    local new_node = minetest.env:get_meta(pointed_thing.above)
    new_node:set_string("owner", player)
	
	return output
end

-- override minetest.node_dig
local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
    local player = digger:get_player_name()
	local meta = minetest.env:get_meta(pos)
	local owner = meta:get_string("owner")
	
	-- do not allow digging other players nodes
	if owner ~= player and owner ~= '' then
		minetest.chat_send_player(player, "You can not dig this node because it is owned by "..owner..".")
		return
	end
	
	-- dig the node
	return old_node_dig(pos, node, digger)
end

-- log that we started
minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))