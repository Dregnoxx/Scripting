netsh interface set interface "Ethernet" disabled
netsh interface set interface "Ethernet" enable
ipconfig /flushdns
ipconfig /release
ipconfig /renew
