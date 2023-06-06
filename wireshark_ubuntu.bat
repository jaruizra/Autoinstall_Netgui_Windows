C:\Windows\System32\wsl.exe  -d ubuntu -e /usr/bin/bash  -c "wireshark -r $(wslpath '%1')"
Pause
