from libqtile.manager import Key, Screen, Group, Click, Drag
from libqtile.command import lazy
from libqtile.layout.base import Layout
from libqtile import layout, bar, widget, hook
from libqtile.layout.xmonad import MonadTall

modkey = "mod4"

keys = [
    # application shortcuts
    Key([modkey], "p", lazy.spawn("exe=`/home/aaronb/.cabal/bin/yeganesh` && eval \"exec $exe\"")),
    Key([modkey, "shift"], "Return", lazy.spawn("urxvt")),
    Key([modkey], "Pause", lazy.spawn("xscreensaver-command --lock")),

    # high-level management
    Key([modkey], "space", lazy.nextlayout()), # cycle layouts
    Key([modkey], "t", lazy.window.disable_floating()), # embed float
    Key([modkey, "shift"], "t", lazy.window.enable_floating()), # pop tile
    Key([modkey, "shift"], "c", lazy.window.kill()), # kill window
    Key([modkey, "shift"], "r", lazy.restart()), # restart qtile
    Key([modkey, "shift"], "l", lazy.shutdown()), # kill qtile

    # layout controls
    Key([modkey], "k", lazy.layout.down()), # focus left
    Key([modkey], "j", lazy.layout.up()), # focus right
    Key([modkey, "shift"], "k", lazy.layout.shuffle_down()), # move tile left
    Key([modkey, "shift"], "j", lazy.layout.shuffle_up()), # move tile right
    Key([modkey], "l", lazy.layout.grow()), # increase tile size
    Key([modkey], "h", lazy.layout.shrink()), # decrease tile size
    Key([modkey], "n", lazy.layout.normalize()), # equalize tiles
    Key([modkey], "o", lazy.layout.maximize()), # maximize tile
    Key([modkey, "shift"], "space", lazy.layout.flip()), # flip orientation
]

mouse = [
    # pop tile
    Drag([modkey], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    # resize float
    Drag([modkey], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    # show float
    Click([modkey], "Button2", lazy.window.bring_to_front()),
]

# Ten virtual-workspaces
# Each available on the left home and under rows
groups = [
    Group("1"), Group("2"), Group("3"), Group("4"), Group("5"), Group("6"),
    Group("7"), Group("8"), Group("9"), Group("0"), Group("-"), Group("=")
]
for i in groups:

    if i.name == "-":
        ikey = "minus"
    elif i.name == "=":
        ikey = "equal"
    else:
        ikey = i.name

    # switch to group
    keys.append(
        Key([modkey], ikey, lazy.group[i.name].toscreen())
    )
    # move tile to group
    keys.append(
        Key([modkey, "shift"], ikey, lazy.window.togroup(i.name))
    )


# Two simple layout instances:
layouts = [
    layout.Max(),
    MonadTall(),
]

# Single screen
# TOP: Cpu graph, Current Layout, Systray
# BOTTOM: Group box, Window name, Clock
screens = [
    Screen(
        bottom = bar.Bar(
            [
                widget.GroupBox(fontsize=16, margin_y=0),
                widget.Sep(height_percent=100, linewidth=2),
                widget.WindowName(fontsize=16, padding=24),
                widget.CurrentLayout(fontsize=18, padding=6),
                widget.Sep(height_percent=100, linewidth=2),
                widget.Clock('%H:%M:%S %d/%m/%y', fontsize=16, padding=6),
            ],
            30,
        ),
    ),

    Screen(
        bottom = bar.Bar(
            [
                widget.GroupBox(fontsize=16, margin_y=0),
                widget.Sep(height_percent=100, linewidth=2),
                widget.WindowName(fontsize=16, padding=24),
                widget.CurrentLayout(fontsize=18, padding=6),
                widget.Systray(),
                widget.Sep(height_percent=100, linewidth=2),
                widget.Clock('%H:%M:%S %d/%m/%y', fontsize=16, padding=6),
            ],
            30,
        ),
    ),
]

# float dialog windows
@hook.subscribe.client_new
def dialogs(window):
    if (window.window.get_wm_type() == 'dialog' or
        window.window.get_wm_transient_for() or
        window.window.get_wm_class()[0] in [
             'gmrun',]):
        window.floating = True

