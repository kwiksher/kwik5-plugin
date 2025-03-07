require "extlib.lunatest"
--

local M = {
  --
  run = function (props)
    print("============ lunatest =============")
    lunatest.reset_suites()
    --
    local UI = props.UI
    --
    local function set (book, page)
      if book == UI.book and page:find(UI.page)  then
        print("  ", "test."..book..".suite_"..page)
        lunatest.suite("test."..book..".suite_"..page, props)
      end
    end

    set("interaction", "swipe")
    set("interaction", "spin")
    set("interaction", "shake")
    set("interaction", "pinch")
    set("interaction", "parallax")
    set("animation", "path_animation")
    set("keyboard", "page1")
    set("lingualSample", "lingual_page2")

    set("replacement","counter")
    set("replacement","dynamicText")
    set("replacement","inputText")
    set("replacement","map")
    set("replacement","mask")
    set("replacement","multiplier")
    set("replacement","particles")
    set("replacement","sprite")
    set("replacement","sync")
    set("replacement","text")
    set("replacement","textinput")
    set("replacement","vector")
    set("replacement","video_png")
    set("replacement","video")
    set("replacement","web")

    -- lunatest.suite("test.book.suite_assets", props)
    -- lunatest.suite("test.book.suite_page1_page_props", props)
    -- lunatest.suite("test.book.suite_page1_interactions", props)
    -- lunatest.suite("test.book.suite_page1_replacements", props)
    -- lunatest.suite("test.book.suite_page1_animation", props)
    -- lunatest.suite("test.book.suite_page1_button", props)
    -- lunatest.suite("test.book.suite_page1_action", props)
    -- lunatest.suite("test.book.suite_page1_group", props)
    -- lunatest.suite("test.book.suite_page1_audio", props)
    -- lunatest.suite("test.book.suite_page1_select_copy_paste", props)

    -- lunatest.suite("test.book.suite_page2_sync2audio", props)
    -- lunatest.suite("test.book.suite_page3_drag", props)
    -- lunatest.suite("test.book.suite_page3_button", props)
    -- lunatest.suite("test.book.suite_page3_animation", props)

    -- lunatest.suite("test.book.suite_page4_physics", props)

    --lunatest.suite("test.book.suite_page12_canvas", props)

    -- lunatest.suite("test.book.suite_new_book_page_layer", props)
    -- lunatest.suite("test.book.suite_new_shape_transform", props)
    -- lunatest.suite("test.book.suite_new_timer", props)
    -- lunatest.suite("test.book.suite_new_variable", props)
    -- lunatest.suite("test.book.suite_page1_new_audio_timer_group_variable", props)

    -- lunatest.suite("test.bookTest.bookTest_importer", props)

    -- lunatest.suite("test.book.suite_controller")
    --  lunatest.suite("test.book.suite_open_vscode", props)
    -- lunatest.suite("test.book.suite_page3_audio", props)
    -- lunatest.suite("test.book.suite_selector", props)
    -- lunatest.suite("test.book.suite_settings", props)
    --lunatest.suite("test.book.suite_page_portrait", props)
    -- lunatest.suite("test.book.suite_page_portrait_replacements", props)
    -- lunatest.suite("test.book.suite_misc", props)

    lunatest.run()
    print("============   end    =============")
  end
}

return M