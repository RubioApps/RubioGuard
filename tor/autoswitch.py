#------------------------------------------------------------------------
# Autoswitch node for TOR connection
# This Python script is execute by a service running on the background
# Please refer to the file 
# https://github.com/RubioApps/RubioGuard/blob/643a6c623825b7ed004894a8fd5356ba872a01cd/tor/torswitch.md
#------------------------------------------------------------------------

import requests
import time
import logging
import json
from systemd.journal import JournalHandler
from stem import Signal
from stem.control import Controller

logger = logging.getLogger(__name__)
handler = JournalHandler(SYSLOG_IDENTIFIER='tor')
handler.setFormatter(logging.Formatter('%(message)s'))
logger.addHandler(handler)
logger.setLevel(logging.INFO)

def get_current_ip():
	session = requests.session()

    # TO Request URL with SOCKS over TOR
	session.proxies = {}
	session.proxies['http']='socks5h://localhost:9050'
	session.proxies['https']='socks5h://localhost:9050'

	try:
		r = session.get('http://httpbin.org/ip')
	except Exception as e:
		return str(e)
	else:
		jsonData = json.loads(r.text)
		return 'Switch the exit node. New origin: ' + jsonData['origin']

def renew_tor_ip():

	with Controller.from_port(port = 9051) as controller:
		controller.authenticate(password="{{YOUR_PLAIN_PASSWORD}}")
		controller.signal(Signal.NEWNYM)

if __name__ == "__main__":
	renew_tor_ip()
	logger.info('%s', get_current_ip())
