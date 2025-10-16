{ config, pkgs, ... }:
{
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # ===== Appearance Settings =====
      gappih=16
      gappiv=16
      gappoh=16
      gappov=16
      borderpx=4
      bordercolor=0x363a4fff
      focuscolor=0xed8796ff
      maxmizescreencolor=0xed8796ff
      
      # ===== Window Effects =====
      border_radius=12
      shadows=1
      shadow_only_floating=0
      shadows_size=5
      shadows_blur=30
      shadows_position_x=0
      shadows_position_y=5
      shadowscolor=0x00000070
      
      blur=1
      blur_layer=0
      
      # ===== Input Configuration =====
      # Focus behavior
      sloppyfocus=1
      warpcursor=1
      focus_cross_monitor=0
      
      # Disable floating window snap
      enable_floating_snap=0
      
      # Disable hot corners for overview
      enable_hotarea=0
      hotarea_size=0

      drag_tile_to_tile=1
      
      # Keyboard
      xkb_rules_layout=gb
      numlockon=1
      repeat_rate=50
      repeat_delay=200
      
      # Mouse
      accel_speed=0.7
      accel_profile=0
      mouse_natural_scrolling=0
      
      # Touchpad
      tap_to_click=1
      trackpad_natural_scrolling=1
      tap_and_drag=1
      drag_lock=1
      disable_while_typing=1
      # Cursor
      cursor_theme=Bibata-Modern-Ice
      cursor_size=24
      cursor_hide_timeout=1
      
      # ===== Layout Configuration =====
      default_mfact=0.5
      default_nmaster=1
      new_is_master=1
      
      # Scroller settings
      scroller_default_proportion=0.5
      scroller_proportion_preset=0.33,0.5,0.67
      scroller_focus_center=0
      
      # ===== Monitor Configuration =====
      monitorrule=DP-4,0.5,1,scroller,0,1,-750,1080,3440,1440,165
      monitorrule=DP-5,0.5,1,scroller,0,1,0,0,1920,1080,75
      
      # ===== Window Rules =====
      windowrule=isfloating:1,appid:librewolf,title:^Picture-in-Picture$
      
      # ===== Environment Variables =====
      env=ELECTRON_OZONE_PLATFORM_HINT,wayland
      env=ELECTRON_ENABLE_WAYLAND,1
      env=CHROMIUM_FLAGS,--enable-features=UseOzonePlatform --ozone-platform=wayland
      env=XDG_CURRENT_DESKTOP,wlr
      env=XDG_SESSION_TYPE,wayland
      env=XDG_SESSION_DESKTOP,wlr
      env=NIXOS_OZONE_WL,1
      env=DISPLAY,:0
      env=XCURSOR_SIZE,24
      
      # ===== Autostart =====
      exec-once=eww open bar0
      exec-once=eww open bar1
      exec-once=swaybg -i /home/hman/Pictures/Wallpapers/evening-sky.png
      exec-once=xwayland-satellite
      exec-once=dunst
      
      # ===== Key Bindings =====
      
      # Application Launchers
      bind=SUPER,Return,spawn,foot
      bind=SUPER,d,spawn,fuzzel
      bind=SUPER,e,spawn,nautilus
      bind=SUPER,w,spawn,librewolf
      bind=SHIFT+SUPER,w,spawn,brave
      bind=ALT+SUPER,l,spawn,swaylock
      bind=SUPER,x,spawn,~/Scripts/fuzzel-bookmarks.sh
      
      # Window Management
      bind=SUPER,q,killclient
      bind=SUPER,o,toggleoverview
      bind=SUPER,v,togglefloating
      bind=SUPER,f,togglemaxmizescreen
      bind=SHIFT+SUPER,f,togglefullscreen
      bind=SUPER,c,centerwin
      
      # Focus Movement 
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down
      
      # Window Movement
      bind=SHIFT+SUPER,h,exchange_client,left
      bind=SHIFT+SUPER,l,exchange_client,right
      bind=SHIFT+SUPER,k,exchange_client,up
      bind=SHIFT+SUPER,j,exchange_client,down
      
      # Monitor Focus
      bind=CTRL+SUPER,h,focusmon,left
      bind=CTRL+SUPER,l,focusmon,right
      bind=CTRL+SUPER,k,focusmon,up
      bind=CTRL+SUPER,j,focusmon,down
      bind=SUPER,space,spawn,/home/hman/Scripts/monitor-focus-toggle.sh
      
      # Move Window to Monitor
      bind=SHIFT+CTRL+SUPER,h,tagmon,left,0
      bind=SHIFT+CTRL+SUPER,l,tagmon,right,0
      bind=SHIFT+CTRL+SUPER,k,tagmon,up,0
      bind=SHIFT+CTRL+SUPER,j,tagmon,down,0
      
      # Workspace/Tag Navigation
      bind=SUPER,u,viewtoleft_have_client
      bind=SUPER,i,viewtoright_have_client
      bind=CTRL+SUPER,u,tagtoleft
      bind=CTRL+SUPER,i,tagtoright
      
      # Direct Tag Access
      bind=SUPER,1,view,1
      bind=SUPER,2,view,2
      bind=SUPER,3,view,3
      bind=SUPER,4,view,4
      bind=SUPER,5,view,5
      bind=SUPER,6,view,6
      bind=SUPER,7,view,7
      bind=SUPER,8,view,8
      bind=SUPER,9,view,9
      
      # Move Window to Tag
      bind=SHIFT+SUPER,1,tag,1
      bind=SHIFT+SUPER,2,tag,2
      bind=SHIFT+SUPER,3,tag,3
      bind=SHIFT+SUPER,4,tag,4
      bind=SHIFT+SUPER,5,tag,5
      bind=SHIFT+SUPER,6,tag,6
      bind=SHIFT+SUPER,7,tag,7
      bind=SHIFT+SUPER,8,tag,8
      bind=SHIFT+SUPER,9,tag,9
      
      # Layout Management
      bind=SUPER,r,switch_proportion_preset
      bind=SHIFT+SUPER,r,switch_layout
      
      # Window Resizing 
      bind=SUPER,minus,increase_proportion,-0.1
      bind=SUPER,equal,increase_proportion,0.1
      
      # Master-stack adjustments 
      bind=SHIFT+SUPER,minus,setmfact,-10
      bind=SHIFT+SUPER,equal,setmfact,+10
      
      # Screenshots
      bind=SHIFT+SUPER,s,spawn,~/Scripts/screenshot-selection.sh
      # Couldn't figure out how to see the currently focused monitor so I made a different bind for each monitor
      bind=None,Print,spawn,~/Scripts/screenshot-screen.sh DP-4
      bind=SHIFT,Print,spawn,~/Scripts/screenshot-screen.sh DP-5

      # Media Keys
      bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+
      bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-
      bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl s +5%
      bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl s -5%
      bind=NONE,XF86AudioPlay,spawn_shell,playerctl --player=spotify play-pause 2>/dev/null; playerctl --ignore-player=spotify play-pause 2>/dev/null
      
      # Exit
      bind=SUPER,m,quit
      
      # Mouse Bindings
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize
      
      # Reload config
      bind=SHIFT+SUPER,M,reload_config
    '';
    autostart_sh = ''
      set +e
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlr
    '';
  };
}
