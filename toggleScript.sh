#!/bin/sh

#  toggleScript.sh
#  Flick
#
#  Created by Nirbhay Agarwal on 05/10/14.
#  Copyright (c) 2014 NSRover. All rights reserved.


export INTERFACESTYLE;INTERFACESTYLE=`defaults read ~/Library/Preferences/.GlobalPreferences.plist AppleInterfaceStyle`;
if [ "$INTERFACESTYLE" == Dark ]; then
INTERFACESTYLE=Light
else
INTERFACESTYLE=Dark