#!/bin/bash

#if more than one connected display
if [ "$(xrandr | grep ' connected' | wc -l)" -gt 1 ] && [ "$1" ]; then
	scaledFromPrimaryDisplay="";
	if [ "$2" = "s" ]; then
		#duplicate mode
		if [ "$1" -eq 11 ]; then
			xrandr --output eDP1 --auto --output HDMI2 --same-as eDP1 --scale-from 1920x1080;
		#external --> right of laptop display	
		elif [ "$1" -eq 12 ]; then
			xrandr --output eDP1 --auto --output HDMI2 --auto --right-of eDP1 --scale-from 1920x1080;
		#external --> left of laptop display	
		elif [ "$1" -eq 21 ]; then
			xrandr --output eDP1 --auto --output HDMI2 --auto --left-of eDP1 --scale-from 1920x1080;
		#only external	
		elif [ "$1" -eq 2 ]; then
			xrandr --output eDP1 --off --output HDMI2 --auto --scale 1x1;
		fi
	else
		#duplicate mode
		if [ "$1" -eq 11 ]; then
			xrandr --output eDP1 --auto --output HDMI2 --same-as eDP1;
		#external --> right of laptop display	
		elif [ "$1" -eq 12 ]; then
			xrandr --output eDP1 --auto --output HDMI2 --auto --right-of eDP1;
		#external --> left of laptop display	
		elif [ "$1" -eq 21 ]; then
			xrandr --output eDP1 --auto --output HDMI2 --auto --left-of eDP1;
		#only external	
		elif [ "$1" -eq 2 ]; then
			xrandr --output eDP1 --off --output HDMI2 --auto --scale 1x1;
		fi	
	fi
else
	xrandr --output eDP1 --auto --output HDMI2 --off;
fi

