import platform
from kitty.boss import get_boss
from kitty.rgb import to_color
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    TabAccessor,
    as_rgb
)
from kitty.utils import color_as_int, log_error

opts = get_options()

MARGIN = 0

SHELLS = {
    "fish": True,
    "bash": True,
    "zsh": True,
    "sh": True,
}

TAB_INDEX_BG = as_rgb(color_as_int(opts.active_border_color))
ACTIVE_TAB_FG = as_rgb(color_as_int(opts.active_tab_foreground))
ACTIVE_TAB_BG = as_rgb(color_as_int(opts.active_tab_background))
INACTIVE_TAB_FG = as_rgb(color_as_int(opts.inactive_tab_foreground))
INACTIVE_TAB_BG = as_rgb(color_as_int(opts.inactive_tab_background))
ACCENT = as_rgb(color_as_int(opts.color3))
BG = as_rgb(color_as_int(opts.background))
FG = as_rgb(color_as_int(opts.foreground))

def is_default_title(name: str) -> bool:
    name = name.lower().strip()
    return name in SHELLS or name == "~"

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if index == 1:
        screen.cursor.x = MARGIN

    title = tab.title
    if is_default_title(title):
        title = platform.node()

    if tab.is_active:
        screen.cursor.bg = TAB_INDEX_BG
        screen.cursor.fg = ACTIVE_TAB_FG
        screen.draw(f" {index} ")
        screen.cursor.bg = ACTIVE_TAB_BG
        screen.cursor.fg = ACTIVE_TAB_FG
        screen.draw(f" {title} ")
    else:
        screen.cursor.bg = INACTIVE_TAB_BG
        screen.cursor.fg = INACTIVE_TAB_FG
        screen.draw(f" {index} {title} ")

    end = screen.cursor.x
    # draw right side
    if is_last:
        width = screen.columns
        right_side = " KITTY "
        # fill space
        padd = width - screen.cursor.x - len(right_side) - MARGIN
        screen.cursor.bg = BG
        screen.cursor.fg = BG
        screen.draw(" "*padd)

        if get_boss().mappings.current_keyboard_mode_name == "prefix":
            screen.cursor.bg = ACCENT
            screen.cursor.fg = BG
        else:
            screen.cursor.bg = TAB_INDEX_BG
            screen.cursor.fg = ACTIVE_TAB_FG
        screen.draw(right_side)

    # idk why do we need to return this but whatever
    # R: it makes the mouse events not do funny stuff
    return end
