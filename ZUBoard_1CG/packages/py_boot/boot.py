#! /usr/bin/env python3

# example #1 - WiFi connection at boot
# ZU Board does not have built in WiFi, so just pure example:
#from pynq.lib import Wifi
#
#port = Wifi()
#port.connect('your_ssid', 'your_password', auto=True)

# example #2 - Change hostname
#import subprocess
#subprocess.call('pynq_hostname.sh aNewHostName'.split())

# example #3 - Load the built in base Overlay for ZU Board on Startup
#from pynq import Overlay
#ol = Overlay('ZUBoard_1CGOverlay.bit')
