{-# OPTIONS_GHC -Wno-deprecations #-}

import XMonad
import XMonad.Hooks.DynamicLog        -- xmobar integration
import XMonad.Hooks.ManageDocks       -- avoid xmobar overlap
import XMonad.Hooks.ManageHelpers     -- for managing dialogs
import XMonad.Hooks.EwmhDesktops      -- for EWMH and fullscreen events
import XMonad.Util.EZConfig           -- for additionalKeys
import XMonad.Util.Run                -- for spawnPipe
import qualified XMonad.StackSet as W
import System.IO                      -- for hPutStrLn
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Util.SpawnOnce

myModMask :: KeyMask
myModMask = mod4Mask

-- | Main: start xmobar and launch Xmonad
main :: IO ()
main = do
    -- Launch xmobar, keep its handle for logging
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobar.hs"
    let myConfig = def
            { terminal           = myTerminal
            , modMask            = myModMask      -- Use Windows key as Mod
            , borderWidth        = 2
            , normalBorderColor  = "#ffffff"
            , focusedBorderColor = "#ff0000"
            , workspaces         = myWorkspaces
            , layoutHook         = myLayoutHook
            , manageHook         = myManageHook <+> manageHook def
            , handleEventHook    = docksEventHook <+> fullscreenEventHook
            , logHook            = dynamicLogWithPP $ xmobarPP
                                       { ppOutput            = hPutStrLn xmproc
                                       , ppTitle             = xmobarColor "#ffffff" "" . shorten 60
                                       , ppCurrent           = const ""           -- hide current workspace
                                       , ppVisible           = const ""           -- hide other visible
                                       , ppHidden            = const ""           -- hide hidden
                                       , ppHiddenNoWindows   = const ""           -- hide hidden w/o windows
                                       , ppLayout            = const ""           -- hide layout info
                                       , ppSep               = ""                 -- no separator
                                       }
            , startupHook        = myStartupHook
            }
    xmonad $ docks $ ewmhFullscreen $ ewmh myConfig
        `additionalKeys`
        -- Keybindings
        [ ((myModMask, xK_t)          , spawn myTerminal)
        , ((myModMask, xK_b)          , spawn "xdg-open https://")
        , ((myModMask, xK_f)          , spawn "xdg-open ~")
        , ((myModMask, xK_r)          , runOrRaisePrompt myXPConfig)
        , ((myModMask, xK_p)          , spawn $
             "rofi -show drun " ++
             "-theme ~/.config/rofi/launchers/type-2/style-2.rasi " ++
             "-config ~/.config/rofi/config.rasi " ++
             "-theme-str '* { font: \"JetBrainsMono Nerd Font 14\"; } window { border-radius: 0px; }'")
        , ((myModMask, xK_o)          , spawn "~/.config/rofi/powermenu/type-2/powermenu.sh")
        , ((myModMask, xK_d)          , kill)
        , ((myModMask, xK_a)          , withFocused (windows . W.sink))
        , ((myModMask, xK_q)          , restart "xmonad" True)
        , ((myModMask, xK_Up)         , spawn "amixer set Master 3%+")
        , ((myModMask, xK_Down)       , spawn "amixer set Master 3%-")
        , ((myModMask, xK_m)          , spawn "amixer set Master toggle")
        -- Toggle xmobar visibility (SIGUSR1)
        , ((myModMask .|. shiftMask, xK_x)  , sendMessage ToggleStruts)
        ]

-- | Terminal emulator
myTerminal :: String
myTerminal = "alacritty"

-- | Single workspace (no switching)
myWorkspaces :: [String]
myWorkspaces = ["1"]  -- Only one workspace: "1"

-- | Layouts: Tall and Full, avoid overlaps with xmobar
myLayoutHook = avoidStruts $ tiled ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1       -- Default number of windows in master pane
    ratio   = 1/2     -- Default proportion for master pane
    delta   = 2/100   -- Percent to resize by

-- | ManageHook: floating dialogs and specific apps
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , isDialog                  --> doFloat
    , title    =? "Zoom"       --> doFloat
    ]

-- | Prompt configuration
myXPConfig = def { font    = "xft:JetBrainsMono Nerd Font:size=14"
                 , bgColor = "#161616"
                 , fgColor = "#ffffff"
				 , borderColor = "#0000ff"
				 , promptBorderWidth = 2
				 , height = 26
				 , position = Top
                 }

-- | StartupHook: autostart applications
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "feh --randomize --bg-fill /usr/share/backgrounds/*.jpg"
    return ()
