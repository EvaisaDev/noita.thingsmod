return function( info, pic_x, pic_y, state_tbl, rmb_func, drag_func, hov_func, hov_scale, slot_dims )
	if( EntityGetName( info.id ) == "kat_book" and not( EntityHasTag( info.id, "forgeable" ))) then
		pen.t.loop( index.D.item_list, function( i, v )
			if( EntityHasTag( v.id, "normal_tablet" )) then
				pen.play_sound( pen.TUNES.VNL.MAGIC_TRIGGER )
				EntityAddTag( info.id, "forgeable" )
				return true
			end
		end)
	end

	index.new_slot_pic( pic_x, pic_y, index.slot_z( info.id, pen.LAYERS.ICONS ), info.pic, false, hov_scale )
	local is_active = state_tbl.is_opened and state_tbl.is_hov and pen.vld( hov_func )
	index.pinning({ "slot", info.id }, is_active, hov_func, { info, "slot", pic_x - 10, pic_y + 7, pen.LAYERS.TIPS })
	
	return info, true
end