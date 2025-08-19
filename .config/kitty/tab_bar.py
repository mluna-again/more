import platform
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

    # draw left side (tab by tab)
    accessor = TabAccessor(tab.tab_id)

    title = tab.title
    if is_default_title(title):
        title = platform.node()

    bg = opts.inactive_tab_background
    fg = opts.inactive_tab_foreground
    if tab.is_active:
        bg = opts.active_tab_background
        fg = opts.active_tab_foreground

    screen.cursor.bg = as_rgb(color_as_int(bg))
    screen.cursor.fg = as_rgb(color_as_int(fg))

    activity_indicator = " "
    if tab.has_activity_since_last_focus or tab.needs_attention:
        activity_indicator = "*"

    screen.draw(f" {index} {title}{activity_indicator} ")

    # draw right side
    if is_last:
        width = screen.columns
        right_side = " KITTY "
        # fill space
        padd = width - screen.cursor.x - len(right_side) - MARGIN
        screen.cursor.bg = as_rgb(color_as_int(opts.inactive_tab_background))
        screen.cursor.fg = as_rgb(color_as_int(opts.inactive_tab_background))
        screen.draw(" "*padd)

        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_background))
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_foreground))
        screen.draw(right_side)

    # idk why do we need to return this but whatever
    return screen.cursor.x
