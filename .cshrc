if ( ! $?prompt ) then
  exit 0
endif
if (-x "`which bash`") then
  setenv OLDSHELL $SHELL
  setenv SHELL `which bash`
  exec bash --login
else
  source .cshrc.body
endif
