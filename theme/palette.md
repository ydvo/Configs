# Theme palette (single source of truth)

Official Amazon Leo brand palette, applied across the niri desktop. These tools
don't share a variable file (niri KDL, mako, fuzzel, swaylock, yazi TOML have no
import mechanism), so each config hardcodes these values. Update here first,
then grep-replace across the configs.

| Role                    | Hex       | Notes                                            |
|-------------------------|-----------|--------------------------------------------------|
| Krypton (accent fill)   | `#8750FF` | Solid fills only: waybar active pill, yazi mode/tab blocks, fuzzel selection. Brand: optimal on light bg. |
| Krypton on dark (accent)| `#B499FF` | Thin accents/text/borders on dark: niri ring/border, mako border, swaylock ring, fuzzel match/border, yazi icons. Brand: optimal on dark bg. |
| Krypton dim             | `#5C00D3` | Muted purple (niri tab inactive, yazi which-key rest). |
| Dark Squid Ink          | `#0F141A` | Anchor background: waybar, mako, fuzzel, swaylock, yazi chrome, niri desktop. |
| Off-White               | `#F5F3EF` | Brand light surface (unused yet).                |
| White                   | `#FFFFFF` | Primary text / text on accent fills.             |
| Neutral gray            | `#888B91` | Muted/secondary text (brand PMS 423).            |
| Urgent / error          | `#ffb4ab` | Kept functional; Leo has no dedicated error color. |

Terminal (foot) background is intentionally left as-is, not part of this palette.

To re-theme after changing a color, from `~/Configs` (case-insensitive):

    sed -i 's/OLDHEX/NEWHEX/Ig' \
      niri/.config/niri/theme.kdl \
      waybar/.config/waybar/style.css \
      mako/.config/mako/config \
      fuzzel/.config/fuzzel/fuzzel.ini \
      swaylock/.config/swaylock/config \
      yazi/.config/yazi/flavors/noctalia.yazi/flavor.toml

Then: `makoctl reload`, SIGUSR2 waybar, niri reloads on save, fuzzel/swaylock/yazi on next launch.
