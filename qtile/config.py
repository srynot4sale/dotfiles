from libqtile.config import Key, Screen, Group, Click, Drag
from libqtile.command import lazy
from libqtile.layout.base import Layout
from libqtile import layout, bar, widget, hook
from libqtile.layout.xmonad import MonadTall

modkey = "mod4"
screen_left = 1
screen_right = 0

lock_command = "dm-tool switch-to-greeter"


keys = [
    # application shortcuts
    Key([modkey], "p", lazy.spawncmd()),
    Key([modkey, "shift"], "Return", lazy.spawn("gnome-terminal")),

    # audio shortcuts
    Key([modkey], "Home", lazy.spawn("/usr/bin/pulseaudio-ctl mute")),
    Key([modkey], "Page_Up", lazy.spawn("/usr/bin/pulseaudio-ctl up")),
    Key([modkey], "Page_Down", lazy.spawn("/usr/bin/pulseaudio-ctl down")),

    # start user-switcher
    Key([modkey], "Pause", lazy.spawn(lock_command)),
    Key(["control", "mod1"], "l", lazy.spawn(lock_command)),
    Key([modkey, "shift"], "l", lazy.spawn(lock_command)),

    # high-level management
    Key([modkey, "shift"], "c", lazy.window.kill()), # kill window
    Key([modkey, "shift"], "r", lazy.restart()), # restart qtile
    Key([modkey, "shift"], "q", lazy.shutdown()), # kill qtile

    # layout controls
    Key([modkey], "t", lazy.window.disable_floating()), # embed float
    Key([modkey, "shift"], "t", lazy.window.enable_floating()), # pop tile
    Key([modkey], "k", lazy.layout.down()), # focus left
    Key([modkey], "j", lazy.layout.up()), # focus right
    Key([modkey, "shift"], "k", lazy.layout.shuffle_down()), # move tile left
    Key([modkey, "shift"], "j", lazy.layout.shuffle_up()), # move tile right
    Key([modkey], "h", lazy.layout.grow()), # increase tile size
    Key([modkey], "l", lazy.layout.shrink()), # decrease tile size
    Key([modkey], "n", lazy.layout.normalize()), # equalize tiles
    Key([modkey], "o", lazy.layout.maximize()), # maximize tile
    Key([modkey], "Tab", lazy.layout.toggle_split()),
    Key([modkey], "space", lazy.next_layout()),
    Key([modkey], "e", lazy.to_screen(screen_left)),
    Key([modkey], "w", lazy.to_screen(screen_right)),
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


# Layout config
layout_theme = {
    "border_width": 1,
    "margin": 0,
    "border_focus": "#66CCCC",
    "border_normal": "#555555"
}

layouts = [
    layout.Max(**layout_theme),
    MonadTall(**layout_theme),
    layout.Stack(num_stacks=2, **layout_theme),
    layout.Tile(**layout_theme),
    layout.Matrix(**layout_theme),
]

screens = [
    Screen(
        bottom = bar.Bar(
            [
                widget.GroupBox(fontsize=14, margin_y=0, padding=7, font="DejaVu Sans Mono"),
                widget.Sep(height_percent=100, linewidth=2),
                widget.WindowName(fontsize=14, padding=24, font="DejaVu Sans Mono"),
                widget.Prompt(fontsize=14, padding=24, font="DejaVu Sans Mono", prompt=""),
                widget.Notify(),
                widget.Systray(),
                widget.CurrentLayout(fontsize=14, padding=6, font="DejaVu Sans Mono"),
                widget.CPUGraph(),
                widget.MemoryGraph(),
                widget.NetGraph(),
                widget.Sep(height_percent=100, linewidth=2),
                widget.Clock(format='%H:%M:%S %d/%m/%y', fontsize=14, padding=6, font="DejaVu Sans Mono"),
            ],
            30,
        ),
    ),

    Screen(
        bottom = bar.Bar(
            [
                widget.GroupBox(fontsize=14, margin_y=0, padding=7, font="DejaVu Sans Mono"),
                widget.Sep(height_percent=100, linewidth=2),
                widget.WindowName(fontsize=14, padding=24, font="DejaVu Sans Mono"),
                widget.CurrentLayout(fontsize=14, padding=6, font="DejaVu Sans Mono"),
                widget.Sep(height_percent=100, linewidth=2),
                widget.Clock(format='%H:%M:%S %d/%m/%y', fontsize=14, padding=6, font="DejaVu Sans Mono"),
            ],
            30,
        ),
    ),
]

# float dialog windows
@hook.subscribe.client_new
def dialogs(window):
    dialog_classes = ['dialog', 'confirm', 'error', 'ssh-askpass', 'pinentry']
    if window.window.get_wm_type() in dialog_classes or window.window.get_wm_transient_for():
        window.floating = True
