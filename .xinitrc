#!/bin/sh

userresources='$HOME/.Xresources'
usermodmap='$HOME/.Xmodmap'
sysresources='/usr/local/etc/X11/xinit/.Xresources'
sysmodmap='/usr/local/etc/X11/xinit/.Xmodmap'

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /usr/local/etc/X11/xinit/xinitrc.d ] ; then
  for f in /usr/local/etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

### Capslock to Control
setxkbmap -option "ctrl:nocaps"

### Fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=xim
export XMODIFIERS=@im=fcitx
/usr/local/bin/mozc start
fcitx -r -d

### Awesome
exec awesome

# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x20+520+0 &
# exec xterm -geometry 80x20+0+0 -name login

