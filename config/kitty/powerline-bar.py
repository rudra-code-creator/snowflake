from kitty.fast_data_types import Screen
from kitty.rgb import Color
from kitty.tab_bar import DrawData, ExtraData, Formatter, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

ICON = "   "
LEFT_SEP = ""
RIGHT_SEP = ""


def __draw_icon(draw_data: DrawData, screen: Screen, index: int) -> int:
    if index != 1:
        return 0
    icon_fg, icon_bg = screen.cursor.fg, screen.cursor.bg

    screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_fg))
    screen.cursor.fg = as_rgb(color_as_int(draw_data.active_fg))
    screen.draw(ICON)

    screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
    screen.cursor.fg = as_rgb(color_as_int(draw_data.inactive_fg))
    screen.draw(RIGHT_SEP)

    screen.cursor.fg, screen.cursor.bg = icon_fg, icon_bg
    return screen.cursor.x


def __draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    max_tab_length: int,
    index: int,
    extra_data: ExtraData,
) -> int:
    tab_bg = screen.cursor.bg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
    else:
        next_tab_bg = default_bg
    screen.cursor.fg = default_bg
    screen.draw(RIGHT_SEP)

    draw_title(draw_data, screen, tab, index, max_tab_length)
    screen.cursor.fg = tab_bg
    screen.cursor.bg = default_bg
    screen.draw(RIGHT_SEP)

    screen.cursor.fg = tab_bg
    screen.cursor.bg = next_tab_bg
    return screen.cursor.x


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
    __draw_icon(draw_data, screen, index)

    return __draw_tab(draw_data, screen, tab, max_title_length, index, extra_data)
