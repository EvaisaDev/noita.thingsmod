return function( info, tid, pic_x, pic_y, pic_z, is_simple )
    local cats = {
        {
            {
                name = "Coralline",
                specie = "Pink Kat",
                science = "Amblycorypha Oblongifolia",
            },{
                name = "Jade",
                specie = "Blue-legged Katydid",
                science = "Zabalius ophthalmicus",
            },{
                name = "Felicia",
                specie = "False Leaf Katydid",
                science = "Pseudophyllus Titan",
            },{
                name = "Lysander",
                specie = "Candycane Cricket",
                science = "Harroweria sp.",
            },{
                name = "Groover",
                specie = "Stick Grasshopper",
                science = "Proscopiidae Iquitos",
            },{
                name = "Argyle",
                specie = "Cave Cricket",
                science = "Tachycines Aynamorus",
            },{
                name = "Virgil",
                specie = "Mole Cricket",
                science = "Neoscapteriscus Borellii",
            },{
                name = "Rook",
                specie = "Dragon Head Cricket",
                science = "Cosmoderus Femoralis",
            },{
                name = "Vess",
                specie = "Dune Cricket",
                science = "Schizodactylus Monstrosus",
            },{
                name = "Grimalkin",
                specie = "Spiny Devil Katydid",
                science = "Panacanthus Cuspidatus",
            },{
                name = "Cecil",
                specie = "Armored Bush Cricket",
                science = "Acanthoplus Discoidalis",
            },{
                name = "Orion",
                specie = "Giant Weta",
                science = "Deinacrida Heteracantha",
            },
        },
        {
            {
                name = "Reginald",
                specie = "Cecropia Moth",
                science = "Hyalophora Cecropia",
            },{
                name = "Silas",
                specie = "Polyphemus Moth",
                science = "Antheraea Polyphemus",
            },{
                name = "Barnaby",
                specie = "Royal Walnut Moth",
                science = "Citheronia Regalis",
            },{
                name = "Sol",
                specie = "Io Moth",
                science = "Automeris Io",
            },{
                name = "Cosmo",
                specie = "Niepelt’s Eyed Silkworm",
                science = "Automeris Niepelti",
            },{
                name = "Willow",
                specie = "Banded Woolly Bear",
                science = "Pyrrharctia Isabella",
            },{
                name = "Mortimer",
                specie = "Puss Moth",
                science = "Cerura Vinula",
            },{
                name = "Finnegan",
                specie = "Mesechites Sphinx",
                science = "Hemeroplanes Triptolemus",
            },{
                name = "Quill",
                specie = "False-Windowed Sphinx",
                science = "Madoryx Pseudothyreus",
            },{
                name = "Pompaduro",
                specie = "Privet Hawkmoth",
                science = "Sphinx Ligustri",
            },{
                name = "Umbra",
                specie = "Elephant Hawkmoth",
                science = "Deilephila Elpenor",
            },{
                name = "Penumbra",
                specie = "Small Elephant Hawkmoth",
                science = "Deilephila Porcellus",
            },{
                name = "Oberon",
                specie = "Oleander Hawkmoth",
                science = "Daphnis Nerii",
            },{
                name = "Archibald",
                specie = "Pink Underwing Moth",
                science = "Phyllodes Imperialis",
            },{
                name = "Zephyr",
                specie = "Spongy Moth",
                science = "Lymantria Dispar",
            },{
                name = "Seraphine",
                specie = "Spicebush Swallowtail",
                science = "Papilio Troilus",
            },{
                name = "Oswald",
                specie = "Black Swallowtail",
                science = "Papilio Polyxenes",
            },{
                name = "Silvester",
                specie = "Great Purple Emperor",
                science = "Sasakia Charonda",
            },{
                name = "Jasmine",
                specie = "Bagworm",
                science = "Psychidae sp.",
            },{
                name = "Percival",
                specie = "Sawfly",
                science = "Trichiosoma Vitellina",
            },
        },
    }

	local xD, xM = index.D, index.M
	if( not( pen.vld( info.pic ))) then return end
	if( not( pen.vld( info.name ))) then return end
	xM.cat_book_state = xM.cat_book_state or {}
	xM.cat_book_page = xM.cat_book_page or {}

	local pic_scale = 1.5
	local icon_w, icon_h = pen.get_pic_dims( info.pic )
	icon_w, icon_h = pic_scale*icon_w, pic_scale*icon_h
    
    local page = xM.cat_book_page[ info.id ] or 0
    local is_reading = xM.cat_book_state[ info.id ] or false
    local readme = is_reading and "[CLOSE]" or "{>wave>{[READ ME]}<wave<}"
    local book = "mods/noita.thingsmod/content/index_compendium/files/cats/bg.png"
    local readme_w, readme_h = pen.get_text_dims( readme, true )

	local title_w, title_h = pen.get_text_dims( info.name, true )
	local desc_w, desc_h = unpack( not( pen.vld( info.desc )) and { 0, 0 }
		or pen.get_tip_dims( info.desc, math.max( title_w + 2, 100 ), -1, -2 ))
    if( is_reading ) then desc_w, desc_h = pen.get_pic_dims( book ) end
	local size_x, size_y = math.max( title_w + 2, desc_w ) + icon_w + 6, math.max( title_h + desc_h + 3, icon_h )

    local is_kat = EntityGetName( info.id ) == "kat_book"
    local book_data = cats[ is_kat and 1 or 2 ]

	return xD.tip_func( "", {
		tid = tid, info = info,
		is_active = true, allow_hover = true,
		is_left = info.in_world, do_corrections = true,
		pic_z = pic_z, pos = { pic_x, pic_y }, dims = { size_x, size_y },
	}, function( t, d )
		local info = d.info
		local size_x, size_y = unpack( d.dims )
		local pic_x, pic_y, pic_z = unpack( d.pos )

		local is_sampo = xD.sampo == info.id
		local inter_alpha = pen.animate( 1, d.t, { ease_out = "exp", frames = d.frames })
		pen.new_shadowed_text( pic_x + d.edging, pic_y + d.edging - 2, pic_z, info.name, {
			dims = { size_x - icon_w - 3, size_y }, fully_featured = true, alpha = inter_alpha,
			color = pen.PALETTE.VNL[( do_runes or is_sampo ) and "RUNIC" or "YELLOW" ]})
		
        local clicked, _, is_hovered = pen.new_interface(
            pic_x + size_x - icon_w - readme_w, pic_y + d.edging - 1, readme_w, readme_h, pic_z )
        if( clicked ) then
            pen.play_sound( pen.TUNES.VNL.CLICK )
            xM.cat_book_state[ info.id ] = not( is_reading )
        end

        pen.new_shadowed_text( pic_x + size_x - icon_w - 7, pic_y + d.edging - 1, pic_z, readme, { is_right_x = true,
            fully_featured = true, alpha = inter_alpha, color = pen.PALETTE.VNL[ is_hovered and "YELLOW" or ( is_reading and "RED" or "RUNIC" )]})
        
        if( is_reading ) then
            local book_x, book_y = pic_x + d.edging + 2, pic_y + d.edging + title_h
            pen.new_image( book_x, book_y, pic_z, book )

            if( page ~= 0 ) then
                local arrow = "mods/noita.thingsmod/content/index_compendium/files/cats/arrowLA.png"
                pen.new_button( book_x + 25, book_y + desc_h - 21, pic_z - 0.1, arrow, {
                    auid = info.id.."_cat_book_l",
                    lmb_event = function( pic_x, pic_y, pic_z, pic, d )
                        pen.atimer( d.auid.."l", nil, true )
                        xM.cat_book_page[ info.id ] = page == 0 and #book_data or page - 1
                        pen.play_sound( pen.TUNES.VNL.CLICK )
                        return pic_x, pic_y, pic_z, pic, d
                    end,
                    hov_event = function( pic_x, pic_y, pic_z, pic, d )
                        return pic_x, pic_y, pic_z, "mods/noita.thingsmod/content/index_compendium/files/cats/arrowLB.png", d
                    end,
                })
            end
            if( page ~= #book_data ) then
                local arrow = "mods/noita.thingsmod/content/index_compendium/files/cats/arrowRA.png"
                pen.new_button( book_x + desc_w - 33, book_y + desc_h - 21, pic_z - 0.1, arrow, {
                    auid = info.id.."_cat_book_r",
                    lmb_event = function( pic_x, pic_y, pic_z, pic, d )
                        pen.atimer( d.auid.."l", nil, true )
                        xM.cat_book_page[ info.id ] = page == #book_data and 0 or page + 1
                        pen.play_sound( pen.TUNES.VNL.CLICK )
                        return pic_x, pic_y, pic_z, pic, d
                    end,
                    hov_event = function( pic_x, pic_y, pic_z, pic, d )
                        return pic_x, pic_y, pic_z, "mods/noita.thingsmod/content/index_compendium/files/cats/arrowRB.png", d
                    end,
                })
            end

            if( page == 0 ) then
                local title = "mods/noita.thingsmod/content/index_compendium/files/cats/title_"..( is_kat and "K" or "C" )..".png"
                pen.new_image( book_x + 55, book_y + 45, pic_z - 0.1, title )
                pen.new_image( book_x + 163, book_y + 20, pic_z - 0.1, "mods/noita.thingsmod/content/index_compendium/files/cats/disclaimer.png" )
                pen.new_text( book_x + 200, book_y + 100, pic_z - 0.1, "While all of the photos are of the real animals, not all specie names are attributed properly. It is incredibly hard to source good pictures, and some genera don't even have a common name.", { dims = { 75, -1 }, is_centered = true, color = pen.PALETTE.SHADOW })
            else
                local names = book_data[ page ]
                pen.new_text( book_x + 73, book_y + 130, pic_z - 0.1,
                    "{>underscore>{{-}|VNL|RUNIC|FORCED|{-}"..names.name.."}<underscore<}",
                    { fully_featured = true, color = pen.PALETTE.SHADOW, is_centered = true })
                pen.new_text( book_x + 73, book_y + 143, pic_z - 0.1, names.specie, { color = {179,160,132}, is_centered = true })
                pen.new_text( book_x + 73, book_y + 152, pic_z - 0.1, names.science, { color = {225,211,183}, is_centered = true })

                local pets_data = pen.t.parse( pen.setting_get( "noita.thingsmod.index_compendium.pets" )) or {}
                local pets = ( pets_data[ is_kat and "k" or "c" ] or {})[ page ] or 0
                local got_pets = false
                
                local frames, s_x, s_y = 15, 0, 0
                local timer = pen.atimer( info.id.."_pets", frames, nil, true )
                local anim = 0.05*( 1 - pen.animate( 1, timer, { ease_int = "hill", params_int = 0.1, frames = frames }))
                
                _,_,is_hovered = pen.new_image( book_x + 18, book_y + 16, pic_z - 0.2,
                    "mods/noita.thingsmod/content/index_compendium/files/cats/frame.png", { can_click = true })
                local l_anim = is_hovered and anim or 0; s_x, s_y = 0.5 - l_anim/5, 0.5 - l_anim
                pen.new_image( book_x + 73 - 108*s_x, book_y + 125 - 216*s_y, pic_z - 0.1,
                    "mods/noita.thingsmod/cats/"..( is_kat and "real_kats/k" or "real_cats/c" )..page..".png", { s_x = s_x, s_y = s_y })
                if( is_hovered ) then
                    pen.new_image( book_x + 10, book_y + 8, pic_z - 0.3,
                        "mods/noita.thingsmod/content/index_compendium/files/cats/pet"..math.ceil( 5*timer/frames )..".png" )
                    if( InputIsMouseButtonDown( 1 )) then got_pets = true end
                end
                _,_,is_hovered = pen.new_image( book_x + 143, book_y + 16, pic_z - 0.2,
                    "mods/noita.thingsmod/content/index_compendium/files/cats/frame.png", { can_click = true })
                local r_anim = is_hovered and anim or 0; s_x, s_y = 0.5 - r_anim/5, 0.5 - r_anim
                pen.new_image( book_x + 198 - 108*s_x, book_y + 125 - 216*s_y, pic_z - 0.1,
                    "mods/noita.thingsmod/cats/"..( is_kat and "real_kats/k" or "real_cats/c" )..page.."_.png", { s_x = s_x, s_y = s_y })
                if( is_hovered ) then
                    pen.new_image( book_x + 135, book_y + 8, pic_z - 0.3,
                        "mods/noita.thingsmod/content/index_compendium/files/cats/pet"..math.ceil( 5*timer/frames )..".png" )
                    if( InputIsMouseButtonDown( 1 )) then got_pets = true end
                end

                if( got_pets and timer == frames ) then
                    pets_data[ is_kat and "k" or "c" ] = pets_data[ is_kat and "k" or "c" ] or {}
                    pets_data[ is_kat and "k" or "c" ][ page ] = pets + 1
                    pen.setting_set( "noita.thingsmod.index_compendium.pets", pen.t.parse( pets_data ))
                    pen.atimer( info.id.."_pets", nil, true )
                    --petting heart particles, hollow knight caterpillar sounds
                end

                pen.new_text( book_x + 143, book_y + 160, pic_z - 0.1, "Times Petted: "..pets, { color = {179,160,132}})

                --[READ MORE] under the adult side that replaces that entire side with text
                --page flipping sound
            end
		elseif( pen.vld( info.desc )) then
			local runic_state = do_runes and pen.magic_storage( info.id, "index_runic_cypher", "value_float", nil, true ) or 1
			if( runic_state ~= 1 ) then
				pen.new_shadowed_text( pic_x + d.edging + 2, pic_y + d.edging + title_h, pic_z,
					"{>runic>{"..info.desc.."}<runic<}", { dims = { desc_w + 2, size_y },
					fully_featured = true, color = pen.PALETTE.VNL.RUNIC, alpha = inter_alpha*( 1 - runic_state ), line_offset = -2 })
				pen.magic_storage( info.id, "index_runic_cypher", "value_float", pen.estimate( "index_runic"..info.id, { 1, 0 }, "exp500" ))
			end
			if( runic_state > 0 ) then
				pen.new_shadowed_text( pic_x + d.edging + 2, pic_y + d.edging + title_h, pic_z + 0.001, info.desc, {
					dims = { desc_w + 2, size_y }, fully_featured = true, alpha = inter_alpha*runic_state, line_offset = -2 })
			end
		end
		
		local inter_size = 15*( 1 - pen.animate( 1, d.t, { ease_out = "wav1.5", frames = d.frames }))
		local pos_x, pos_y = pic_x + 0.5*inter_size, pic_y + 0.5*inter_size
		local scale_x, scale_y = size_x - inter_size, size_y - inter_size
		
		local gui, uid = pen.gui_builder()
		GuiOptionsAddForNextWidget( gui, 2 ) --NonInteractive
		GuiZSetForNextWidget( gui, pic_z + 0.01 )
		local tip_bg = "data/ui_gfx/decorations/9piece0"..( is_sampo and "" or "_gray" )..".png"
		GuiImageNinePiece( gui, uid, pos_x, pos_y, scale_x, scale_y, 1.15*math.max( 1 - inter_alpha/6, 0.1 ), tip_bg )
		
		local icon_x, icon_y = pos_x + scale_x - ( d.edging + icon_w ), pos_y + ( scale_y - icon_h )/2
		pen.new_image( icon_x, icon_y, pic_z, info.pic, { s_x = pic_scale, s_y = pic_scale, alpha = inter_alpha })

        return pen.new_interface( pic_x - 2, pic_y - 2, size_x + 4, size_y + 4, pic_z + 0.1 )
	end)
end