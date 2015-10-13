#! /bin/sh

sound_data=$(amixer sget Master | tail -n 1 | awk '{print $5" "$6}')
sound_volume=$(echo $sound_data | awk '{print $1}' | tr -d '[]%')
sound_mute=$(echo $sound_data | awk '{print $2}' | tr -d '[]')

sound_state="$(echo $sound_mute | sed 's/on/-/;s/off/M/') \
$(echo $sound_volume)"

echo "$sound_state"