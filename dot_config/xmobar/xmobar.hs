Config
  { font            = "JetBrainsMono Nerd Font SemiBold 14"
  , iconRoot        = "/home/oivas000/.config/xmobar/icons/"
  , bgColor         = "#171717"
  , fgColor         = "#ffffff"
  , position        = TopH 26
  , lowerOnStart    = True
  , hideOnStart     = False
  , allDesktops     = True
  , overrideRedirect = True
  , persistent      = False

  , commands =
      [ Run StdinReader

      , Run Memory
          [ "-t"
          , "<icon=memory.xpm/> <usedratio>%"
          ] 10

      , Run Cpu
          [ "-t"
          , "<icon=cpu.xpm/> <total>%"
          ] 10

      , Run Com "bash"
          [ "-c"
          , "echo '<action=`rofi -show drun -theme ~/.config/rofi/launchers/type-2/style-2.rasi -config ~/.config/rofi/config.rasi -theme-str \"* { font: \\\"JetBrainsMono Nerd Font 14\\\"; } window { border-radius: 0px; }\"`><icon=launcher.xpm/></action>'"
          ]
          "launcher" 10

      , Run Com "bash"
          [ "-c"
          , "amixer get Master | awk -F'[][]' '/Front Left:/ { vol = $2; state = $4; gsub(\"%\", \"\", vol); vol_num = vol + 0; icon = (state == \"off\") ? \"<icon=volume-mute.xpm/> \" : (vol_num == 0) ? \"<icon=volume-off.xpm/> \" : (vol_num <= 30) ? \"<icon=volume-low.xpm/> \" : (vol_num <= 70) ? \"<icon=volume-medium.xpm/> \" : \"<icon=volume-high.xpm/> \"; print \"<action=amixer set Master toggle>\" icon vol \"%</action>\"; }'"
          ]
          "volume" 10

      , Run Date
          "%H:%M:%S | %e %B %Y" "date" 10

      , Run Com "bash"
          [ "-c"
          , "nmcli -t -f STATE general | grep -q '^connected' && echo '<action=`nmcli networking off`><fc=#ffffff,#4444ff><icon=network.xpm/></fc></action>' || echo '<action=`nmcli networking on`><fc=#ffffff,#4444ff><icon=network-no.xpm/></fc></action>'"
          ]
          "net" 10

      , Run Com "bash"
          [ "-c"
          , "echo '<action=~/.config/rofi/powermenu/type-2/powermenu.sh><icon=power.xpm/></action>'"
          ]
          "power" 3600
      ]

  , sepChar   = "%"
  , alignSep  = "}{"
  , template  = " %launcher% | %StdinReader% }{ %cpu% | %memory% | %volume% | %net% | %date% | %power% "
  }
