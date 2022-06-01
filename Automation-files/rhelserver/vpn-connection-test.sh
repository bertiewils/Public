#!/bin/bash
if ip a | grep wg0; then echo ""; else wg-quick up wg0; fi
if ping -c 10 10.8.0.1; then echo ""; else sudo wg-quick down wg0 && sudo wg-quick up wg0; fi
