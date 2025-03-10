def test_calcstringbox_works_in_tests(_args, assert)
  w, h = $gtk.calcstringbox('1234567890', 0, '')
  assert.true! w > 0
  assert.true! h > 0
end

def test_calcstringbox_new_line_has_no_width(_args, assert)
  w, h = $gtk.calcstringbox("\n", 0, '')
  assert.equal! w, 0.0
  assert.equal! h, 22.0 # Yep, it has a height
end

def test_calcstringbox_double_new_line_has_no_width(_args, assert)
  w, h = $gtk.calcstringbox("\n\n", 0, '')
  assert.equal! w, 0.0
  assert.equal! h, 22.0 # Yep, it has a height
end

def test_calcstringbox_with_day_roman_new_line_has_width(_args, assert)
  w, h = $gtk.calcstringbox("\n\n", 0, 'fonts/day-roman/DAYROM__.ttf')
  assert.false! w == 0.0 # :/
  assert.false! h == 0.0 # :/
end

def test_calcstringbox_tab_has_no_witdh(_args, assert)
  w, h = $gtk.calcstringbox("\t", 0, '')
  assert.equal! w, 0.0 # Yep, it has no width :/
  assert.equal! h, 22.0 # Yep, it has a height
end

# ---------------------- Util color tests ---------------------

def test_parse_color_integer_rgb(_args, assert)
  assert.equal! Input::Util.parse_color({ test_color: 0 }, 'test'), { r: 0, g: 0, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: 0xFF0000 }, 'test'), { r: 255, g: 0, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: 0x00FF00 }, 'test'), { r: 0, g: 255, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: 0x0000FF }, 'test'), { r: 0, g: 0, b: 255, a: 255 }
end

def test_parse_color_integer_rgba(_args, assert)
  # NOTE: For Integer (hex) rgba to work, there has to be a red component > 0
  assert.equal! Input::Util.parse_color({ test_color: 0x01000000 }, 'test'), { r: 1, g: 0, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: 0xFF000000 }, 'test'), { r: 255, g: 0, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: 0x01FF0000 }, 'test'), { r: 1, g: 255, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: 0x0100FF00 }, 'test'), { r: 1, g: 0, b: 255, a: 0 }
end

def test_parse_color_array_rgb(_args, assert)
  assert.equal! Input::Util.parse_color({ test_color: [255, 0, 0] }, 'test'), { r: 255, g: 0, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 255, 0] }, 'test'), { r: 0, g: 255, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 0, 255] }, 'test'), { r: 0, g: 0, b: 255, a: 255 }
end

def test_parse_color_array_rgb_da(_args, assert)
  assert.equal! Input::Util.parse_color({ test_color: [255, 0, 0] }, 'test', da: 1), { r: 255, g: 0, b: 0, a: 1 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 255, 0] }, 'test', da: 1), { r: 0, g: 255, b: 0, a: 1 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 0, 255] }, 'test', da: 1), { r: 0, g: 0, b: 255, a: 1 }
end

def test_parse_color_array_rgba(_args, assert)
  assert.equal! Input::Util.parse_color({ test_color: [255, 0, 0, 0] }, 'test'), { r: 255, g: 0, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 255, 0, 0] }, 'test'), { r: 0, g: 255, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 0, 255, 0] }, 'test'), { r: 0, g: 0, b: 255, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: [0, 0, 0, 0] }, 'test'), { r: 0, g: 0, b: 0, a: 0 }
end

def test_parse_color_hash_rgba(_args, assert)
  assert.equal! Input::Util.parse_color({ test_color: { r: 255, g: 0, b: 0, a: 0 } }, 'test'), { r: 255, g: 0, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: { r: 0, g: 255, b: 0, a: 0 } }, 'test'), { r: 0, g: 255, b: 0, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: { r: 0, g: 0, b: 255, a: 0 } }, 'test'), { r: 0, g: 0, b: 255, a: 0 }
  assert.equal! Input::Util.parse_color({ test_color: { r: 0, g: 0, b: 0, a: 0 } }, 'test'), { r: 0, g: 0, b: 0, a: 0 }
end

def test_parse_color_hash_component(_args, assert)
  assert.equal! Input::Util.parse_color({ test_color: { r: 255 } }, 'test'), { r: 255, g: 0, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: { g: 255 } }, 'test'), { r: 0, g: 255, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: { b: 255 } }, 'test'), { r: 0, g: 0, b: 255, a: 255 }
  assert.equal! Input::Util.parse_color({ test_color: { a: 0 } }, 'test'), { r: 0, g: 0, b: 0, a: 0 }
end

def test_parse_color_nil(_args, assert)
  assert.equal! Input::Util.parse_color({}, 'test'), { r: 0, g: 0, b: 0, a: 255 }
  assert.equal! Input::Util.parse_color_nilable({}, 'test'), nil
end

# ---------------------- Word break tests ---------------------

def test_find_word_break_left(_args, assert)
  assert_finds_word_break_left(assert, '|word test', '|word test')
  assert_finds_word_break_left(assert, 'wo|rd test', '|word test')
  assert_finds_word_break_left(assert, 'word| test', '|word test')
  assert_finds_word_break_left(assert, 'word |test', '|word test')
  assert_finds_word_break_left(assert, 'word t|est', 'word |test')
  assert_finds_word_break_left(assert, 'word test|', 'word |test')
end

def test_find_word_break_right(_args, assert)
  assert_finds_word_break_right(assert, '|word test', 'word| test')
  assert_finds_word_break_right(assert, 'wo|rd test', 'word| test')
  assert_finds_word_break_right(assert, 'wor|d test', 'word| test')
  assert_finds_word_break_right(assert, 'word| test', 'word test|')
  assert_finds_word_break_right(assert, 'word |test', 'word test|')
  assert_finds_word_break_right(assert, 'word t|est', 'word test|')
  assert_finds_word_break_right(assert, 'word test|', 'word test|')
end

# ---------------------- Current word tests -------------------

def test_finds_current_word(_args, assert)
  assert_current_word(assert, '|word test', nil)
  assert_current_word(assert, 'w|ord test', 'word')
  assert_current_word(assert, 'wor|d test', 'word')
  assert_current_word(assert, 'word| test', 'word')
  assert_current_word(assert, 'word |test', nil)
end

# ---------------------- Line wrap tests ----------------------

def test_find_word_breaks_empty_value(_args, assert)
  assert.equal! word_wrap_result(''), ['']
end

def test_find_word_breaks_single_space(_args, assert)
  assert.equal! word_wrap_result(' '), [' ']
end

def test_find_word_breaks_single_char(_args, assert)
  assert.equal! word_wrap_result('a'), ['a']
end

def test_multiline_word_breaks_two_words(_args, assert)
  assert.equal! word_wrap_result('Hello, world'), ['Hello, ', 'world']
end

def test_find_word_breaks_leading_and_trailing_white_space(_args, assert)
  assert.equal! word_wrap_result(" \t  hello \t "), [" \t  hello \t "]
end

def test_find_word_breaks_leading_and_trailing_white_space_multiple_words(_args, assert)
  assert.equal! word_wrap_result(" \t  hello, \t  world \t"), [" \t  hello, \t  ", "world \t"]
end

def test_multiline_word_breaks_trailing_new_line(_args, assert)
  assert.equal! word_wrap_result("hello, \n"), ['hello, ', "\n"]
end

def test_multiline_word_breaks_new_line(_args, assert)
  assert.equal! word_wrap_result("hello, \n  world"), ['hello, ', "\n  world"]
end

def test_multiline_word_breaks_double_new_line(_args, assert)
  assert.equal! word_wrap_result("hello, \n\n  world"), ['hello, ', "\n", "\n  world"]
end

def test_multiline_word_breaks_multiple_new_lines(_args, assert)
  assert.equal! word_wrap_result("hello, \n\n\n  world"), ['hello, ', "\n", "\n", "\n  world"]
end

def test_perform_word_wrap_multiple_new_lines(_args, assert)
  assert.equal! word_wrap_result("1\n\n\n2"), ['1', "\n", "\n", "\n2"]
end

def test_perform_word_wrap_trailing_new_line(_args, assert)
  assert.equal! word_wrap_result("1\n"), ['1', "\n"]
end

def test_find_word_breaks_trailing_new_line_after_wrap(_args, assert)
  assert.equal! word_wrap_result("1234567890 1234567890 1234567890\n"), ['1234567890 ', '1234567890 ', '1234567890', "\n"]
end

def test_multiline_word_breaks_a_very_long_word(_args, assert)
  assert.equal! word_wrap_result('Supercalifragilisticexpialidocious'), ['Supercalif', 'ragilistic', 'expialidoc', 'ious']
end

def test_multiline_word_breaks_breaks_very_long_word_after_something_that_isnt(_args, assert)
  assert.equal! word_wrap_result('Super califragilisticexpialidocious'), ['Super ', 'califragil', 'isticexpia', 'lidocious']
end

# ---------------------- Max length tests ----------------------

def test_no_max_length(_args, assert)
  input = build_text_input('1234567890', 10, 10)
  input.insert('abc')

  assert.equal! input.value.to_s, '1234567890abc'
  assert.equal! input.selection_end, 13
  assert.equal! input.selection_start, 13
end

def test_max_length(_args, assert)
  input = build_text_input('1234567890', 10, 10, max_length: 10)
  input.insert('abc')

  assert.equal! input.value.to_s, '1234567890'
  assert.equal! input.selection_end, 10
  assert.equal! input.selection_start, 10
end

def test_max_length_inserts_as_much_as_possible(_args, assert)
  input = build_text_input('1234567890', 10, 10, max_length: 11)
  input.insert('abc')

  assert.equal! input.value.to_s, '1234567890a'
  assert.equal! input.selection_end, 11
  assert.equal! input.selection_start, 11
end

def test_max_length_inserts_as_much_as_possible_in_the_middle(_args, assert)
  input = build_text_input('1234567890', 5, 5, max_length: 11)
  input.insert('abc')

  assert.equal! input.value.to_s, '12345a67890'
  assert.equal! input.selection_end, 6
  assert.equal! input.selection_start, 6
end

def test_max_length_inserts_as_much_as_possible_in_the_middle_overwriting(_args, assert)
  input = build_text_input('1234567890', 5, 6, max_length: 11)
  input.insert('abc')

  assert.equal! input.value.to_s, '12345ab7890'
  assert.equal! input.selection_end, 7
  assert.equal! input.selection_start, 7
end

# ---------------------- Font size calculation tests ----------------------

def test_default_height_is_calculated_from_padding_and_font_height(_args, assert)
  _, font_height = $gtk.calcstringbox('A', 0)
  text_input = Input::Text.new(padding: 10, size_enum: 0)

  assert.equal! text_input.h, font_height + 20
end

def test_multiline_scrolls_in_font_height_steps_by_default(args, assert)
  $args = args
  _, font_height = $gtk.calcstringbox('A', 0)
  input = Input::Multiline.new(x: 100, y: 100, w: 100, size_enum: 0)
  input.insert "line 1\n"
  input.insert "line 2\n"
  input.insert "line 3\n"

  assert.equal! input.scroll_y, 0

  mouse_is_inside(input)
  args.inputs.mouse.wheel = { y: 1 }
  input.tick

  assert.equal! input.scroll_y, font_height
end

def test_text_click_inside_sets_selection(args, assert)
  $args = args
  three_letters_wide, _ = $gtk.calcstringbox('ABC', 0)
  input = Input::Text.new(x: 100, y: 100, w: 100, size_enum: 0, value: 'ABCDEF', focussed: true)

  mouse_is_inside(input, x: 100 + three_letters_wide)
  mouse_down
  input.tick

  mouse_up
  input.tick

  assert.equal! input.selection_start, 3
  assert.equal! input.selection_end, 3
end

def test_text_drag_inside_sets_selection(args, assert)
  $args = args
  three_letters_wide, _ = $gtk.calcstringbox('ABC', 0)
  six_letters_wide, _ = $gtk.calcstringbox('ABCDEF', 0)
  input = Input::Text.new(x: 100, y: 100, w: 100, size_enum: 0, value: 'ABCDEFGH', focussed: true)

  mouse_is_inside(input, x: 100 + three_letters_wide)
  mosue_down
  input.tick
  mouse_is_inside(input, x: 100 + six_letters_wide)
  mouse_up
  input.tick

  assert.equal! input.selection_start, 3
  assert.equal! input.selection_end, 6
end

def test_multiline_click_inside_sets_selection(args, assert)
  $args = args
  three_letters_wide, font_height = $gtk.calcstringbox('ABC', 0)
  input = Input::Multiline.new(x: 100, y: 100, w: 100, h: font_height * 2, size_enum: 0, value: "ABCDEF\nGHIJKL", focussed: true)
  inside_second_line_y = input.y + font_height.half

  mouse_is_at(100 + three_letters_wide, inside_second_line_y)
  mouse_down
  input.tick
  mouse_up
  input.tick


  # 10 = ABCDEF\nGHI
  assert.equal! input.selection_start, 10
  assert.equal! input.selection_end, 10
end

def test_text_drag_inside_sets_selection(args, assert)
  $args = args
  three_letters_wide, font_height = $gtk.calcstringbox('ABC', 0)
  input = Input::Multiline.new(x: 100, y: 100, w: 100, h: font_height * 2, size_enum: 0, value: "ABCDEF\nGHIJKL", focussed: true)
  inside_second_line_y = input.y + font_height.half
  inside_first_line_y = inside_second_line_y + font_height

  mouse_is_at(100 + three_letters_wide, inside_first_line_y)
  mouse_down
  input.tick

  mouse_is_at(100 + three_letters_wide, inside_second_line_y)
  mouse_up
  input.tick

  assert.equal! input.selection_start, 3
  assert.equal! input.selection_end, 10
end

# Two representative test cases using size_px instead of size_enum

def test_default_height_is_calculated_from_padding_and_font_height_size_px(_args, assert)
  _, font_height = $gtk.calcstringbox('A', size_px: 30)
  text_input = Input::Text.new(padding: 10, size_px: 30)

  assert.equal! text_input.h, font_height + 20
end

def test_text_drag_inside_sets_selection_size_px(args, assert)
  $args = args
  three_letters_wide, _ = $gtk.calcstringbox('ABC', size_px: 44)
  six_letters_wide, _ = $gtk.calcstringbox('ABCDEF', size_px: 44)
  input = Input::Text.new(x: 100, y: 100, w: 200, size_px: 44, value: 'ABCDEFGH', focussed: true)

  mouse_is_inside(input, x: 100 + three_letters_wide)
  mouse_down
  input.tick
  mouse_is_inside(input, x: 100 + six_letters_wide)
  mouse_up
  input.tick

  assert.equal! input.selection_start, 3
  assert.equal! input.selection_end, 6
end

# ---------------------- menu tests --------------------------

def test_menu_constrains_selected_index(args, assert)
  menu = Input::Menu.new(items: %w[1 2 3])

  menu.selected_index = 0
  assert.equal! menu.selected_index, 0

  menu.selected_index = 1
  assert.equal! menu.selected_index, 1

  menu.selected_index = 2
  assert.equal! menu.selected_index, 2

  menu.selected_index = 3
  assert.equal! menu.selected_index, 0

  menu.selected_index = -1
  assert.equal! menu.selected_index, 2
end

def test_menu_calculates_menu_items_to_show_short_odd(args, assert)
  menu = Input::Menu.new(items: %w[1 2 3])

  menu.selected_index = 0
  assert.equal! menu.items_to_show(110), [0, 3], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 1
  assert.equal! menu.items_to_show(110), [0, 3], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 2
  assert.equal! menu.items_to_show(110), [0, 3], "with selected_index: #{menu.selected_index}"
end

def test_menu_calculates_menu_items_to_show_short_even(args, assert)
  menu = Input::Menu.new(items: %w[1 2 3 4])

  menu.selected_index = 0
  assert.equal! menu.items_to_show(110), [0, 4], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 1
  assert.equal! menu.items_to_show(110), [0, 4], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 2
  assert.equal! menu.items_to_show(110), [0, 4], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 3
  assert.equal! menu.items_to_show(110), [0, 4], "with selected_index: #{menu.selected_index}"
end

def test_menu_calculates_menu_items_to_show_long(args, assert)
  menu = Input::Menu.new(items: (0..999).to_a.map(&:to_s))

  menu.selected_index = 0
  assert.equal! menu.items_to_show(110), [0, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 1
  assert.equal! menu.items_to_show(110), [0, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 2
  assert.equal! menu.items_to_show(110), [0, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 3
  assert.equal! menu.items_to_show(110), [1, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 4
  assert.equal! menu.items_to_show(110), [2, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 5
  assert.equal! menu.items_to_show(110), [3, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 150
  assert.equal! menu.items_to_show(110), [148, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 995
  assert.equal! menu.items_to_show(110), [993, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 996
  assert.equal! menu.items_to_show(110), [994, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 997
  assert.equal! menu.items_to_show(110), [995, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 998
  assert.equal! menu.items_to_show(110), [995, 5], "with selected_index: #{menu.selected_index}"

  menu.selected_index = 999
  assert.equal! menu.items_to_show(110), [995, 5], "with selected_index: #{menu.selected_index}"
end

# ---------------------- helper methods ----------------------

def build_text_input(value, selection_start = 0, selection_end = selection_start, **attr)
  Input::Text.new(value: value, selection_start: selection_start, selection_end: selection_end, **attr)
end

def make_word_break_error(input, actual, expected)
  <<-EOS
    Starting '#{input.value.to_s.dup.insert(input.selection_end, '|')}'
    Actual   '#{input.value.to_s.dup.insert(actual, '|')}'
    Expected '#{input.value.to_s.dup.insert(expected, '|')}'
  EOS
end

def assert_finds_word_break_left(assert, starting, expected)
  selection_end = starting.index('|')
  expected = expected.index('|')
  input = build_text_input(starting.delete('|'), selection_end)
  actual = input.find_word_break_left
  assert.equal! actual, expected, make_word_break_error(input, actual, expected)
end

def assert_finds_word_break_right(assert, starting, expected)
  selection_end = starting.index('|')
  expected = expected.index('|')
  input = build_text_input(starting.delete('|'), selection_end)
  actual = input.find_word_break_right
  assert.equal! actual, expected, make_word_break_error(input, actual, expected)
end

def make_current_word_error(input, actual, expected)
  <<-EOS
    Starting '#{input.value.to_s.dup.insert(input.selection_end, '|')}'
    Actual   #{actual.nil? ? 'nil' : "'#{actual}'"}
    Expected #{expected.nil? ? 'nil' : "'#{expected}'"}
  EOS
end

def assert_current_word(assert, starting, expected)
  selection_end = starting.index('|')
  input = build_text_input(starting.delete('|'), selection_end)
  actual = input.current_word
  assert.equal! actual, expected, make_current_word_error(input, actual, expected)
end

def build_multiline_input(width_in_letters)
  # This works because the default DR font is monospaced
  width, _ = $gtk.calcstringbox('1' * width_in_letters, 0)
  Input::Multiline.new(w: width)
end

def word_wrap_result(string, width_in_letters = 10)
  multiline = build_multiline_input(10)
  multiline.insert string
  multiline.lines.map(&:text)
end

def mouse_is_at(x, y)
  $args.inputs.mouse.x = x
  $args.inputs.mouse.y = y
end

def mouse_is_inside(rect, x: nil)
  mouse_is_at(
    x || rect.x + rect.w.half,
    rect.y + rect.h.half
  )
end

def mouse_down
  $args.inputs.mouse.button_left = true
  $args.inputs.mouse.click = GTK::MousePoint.new($args.inputs.mouse.x, $args.inputs.mouse.y)
  $args.inputs.mouse.up = false
end

def mouse_up
  $args.inputs.mouse.button_left = false
  $args.inputs.mouse.click = nil
  $args.inputs.mouse.up = true
end

# ---------------------- delete_back ----------------------

def test_delete_back(_args, assert)
  input = build_text_input('1234567890', 10, 10)
  input.delete_back

  assert.equal! input.value.to_s, '123456789'
  assert.equal! input.selection_end, 9
  assert.equal! input.selection_start, 9
end

def test_delete_back_empty_value(_args, assert)
  input = build_text_input('', 0, 0)
  input.delete_back

  assert.equal! input.value.to_s, ''
  assert.equal! input.selection_end, 0
  assert.equal! input.selection_start, 0
end
