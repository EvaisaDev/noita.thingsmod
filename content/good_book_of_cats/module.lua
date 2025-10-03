local gui_options = require "lib.gui.gui_options"
---@type Module
local M = {
    name = "The Good Book of Cats",
    description = "Adds the Good Book of Cats",
    authors = { "dextercd" },
}

local gui

local cats = {
    {
        img = "mods/noita.thingsmod/cats/skittle.jpg",
        name = "Skittle"
    },
    {
        img = "mods/noita.thingsmod/cats/evil_beast.png",
        name = "Evil Beast",
    },
    {
        img = "mods/noita.thingsmod/cats/alesx_droolemoji.jpg",
        name = "Alex",
    },
    {
        img = "mods/noita.thingsmod/cats/james.jpg",
        name = "James",
    },
    {
        img = "mods/noita.thingsmod/cats/monty.jpg",
        name = "Monty",
    },
    {
        img = "mods/noita.thingsmod/cats/roger.jpg",
        name = "Roger",
    },
    {
        img = "mods/noita.thingsmod/cats/ella.png",
        name = "Ella",
    },
}

function M.OnModInit()
    gui = GuiCreate()
end

local page_nr = 1

local text_offset = 5

local function draw_cat(cat, id, x, y, width)
    local cat_width, cat_height = GuiGetImageDimensions(gui, cat.img)
    local scale = width / cat_width

    GuiImage(gui, id, x, y, cat.img, 1, scale)

    local height = cat_height * scale
    local text_x = x + text_offset
    local text_y = y + height + text_offset
    GuiColorSetForNextWidget(gui, 0.1, 0.1, 0.1, 1)
    GuiText(gui, text_x, text_y, cat.name)
end

function M.OnWorldPreUpdate()
    GuiStartFrame(gui)
    GuiOptionsAdd(gui, gui_options.NoPositionTween)
    if GameGetIsGamepadConnected() then
        GuiOptionsAdd(gui, gui_options.NonInteractive)
    end

    if not GameHasFlagRun("NOITA_THINGSMOD_CAT_BOOK_HELD") then
        return
    end

    local ui_width, ui_height = GuiGetScreenDimensions(gui)
    local img_width, img_height = GuiGetImageDimensions(gui, "mods/noita.thingsmod/content/good_book_of_cats/gfx/book_ui.png")

    local scale = ui_height / img_height * 0.9
    local book_y = ui_height * 0.05
    local book_x = (ui_width - img_width * scale) / 2

    GuiZSet(gui, 500)
    GuiImage(gui, 220, book_x, book_y, "mods/noita.thingsmod/content/good_book_of_cats/gfx/book_ui.png", 1, scale)

    GuiZSet(gui, 300)

    local book_width = img_width * scale
    local book_height = img_height * scale

    local page_width = book_width * 0.5
    local picture_width = page_width * 0.7

    if cats[page_nr] then
        draw_cat(cats[page_nr], 230, ui_width * 0.5 - picture_width - 11, book_y + 45, picture_width)
    end

    if cats[page_nr+1] then
        draw_cat(cats[page_nr+1], 240, ui_width * 0.5 + 24, book_y + 60, picture_width)
    end

    local button_width, button_height = GuiGetImageDimensions(gui, "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png")

    if page_nr > 1
    and GuiImageButton(
        gui,
        250,
        book_x,
        book_y + book_height - button_height,
        "Back",
        "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png")
    then
        page_nr = page_nr - 2
    end

    if page_nr + 1 < #cats
    and GuiImageButton(
        gui,
        260,
        book_x + book_width - button_width,
        book_y + book_height - button_height - 10,
        "Next",
        "mods/noita.thingsmod/content/good_book_of_cats/gfx/button.png")
    then
        page_nr = page_nr + 2
    end
end

function M.OnPlayerFirstSpawned(player_id)
    local x, y = EntityGetTransform(player_id)
    EntityLoad("mods/noita.thingsmod/content/good_book_of_cats/entities/book.xml", x - 20, y - 400)
end

return M
