@echo off

echo ----------------------------------------------------
echo 按任意键清理这些垃圾东西
echo  *.aps *.idb *.ncp *.obj *.pch *.tmp *.sbr
echo ----------------------------------------------------
pause

del /F /Q /S *.aps *.idb *.ncp *.obj *.pch *.sbr *.tmp *.pdb *.bsc *.ilk *.res *.ncb *.opt *.suo *.manifest *.dep Thumbs.db

pause


