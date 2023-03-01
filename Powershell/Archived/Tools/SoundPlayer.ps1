$soundPlayer = New-Object System.Media.SoundPlayer
$soundPlayer.SoundLocation="$env:windir\Media\notify.wav"
$soundPlayer.PlaySync()
"Done."

#$soundPlayer.Stop() 暂停播放
