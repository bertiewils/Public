#!/bin/bash
if ip a | grep wg0; then echo ""; else wg-quick up wg0; fi
if ping -c 10 <REDACTED>; then echo ""; else sudo wg-quick down wg0 && sudo wg-quick up wg0; fi
