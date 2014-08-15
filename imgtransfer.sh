#!/bin/bash
sleep 5

SOURCE=${1:-"/media/sdcard"}
# default to /mnt/camSD
DEST=${2:-"/media/hd/pictures/"}
# default to home/<currentuser>/Pictures
#UUID=null # You can get this value with `blkid /dev/sdX#`

function moveImages {
	/bin/mount /dev/mmcblk0p1 ${SOURCE}
	cd /sys/class/leds/status\:green\:health
	subDEST=$(date +"%Y/%m/%d")
	/media/hd/scripts/nma.sh SD2GlaDoS CopyImages CopyingPhotos 1
	#for img in `find ${SOURCE} -maxdepth 10 -type f -name "*.JPG"`; do
	for img in `find ${SOURCE} -mindepth 1 -type f -name "*.JPG"`; do
        	echo  heartbeat > trigger
		#echo 'Found Image'
		if [ ! -d ${DEST}${subDEST} ]; then
			#echo 'The destination does not exist... making directory ${DEST}${subDEST}'
			mkdir -p ${DEST}${subDEST}
		fi
		#echo "Moving ${img} to ${DEST}${subDEST}"
		cp ${img} ${DEST}${subDEST}
	done
	#sync
	echo  default-on > trigger
	cd /sys/class/leds/status\:red\:fault
	echo heartbeat > trigger
	
	/media/hd/scripts/nma.sh SD2GlaDoS CopyImages CopyingVideos 1
	cp /media/sdcard/PRIVATE/AVCHD/ ${DEST}${subDEST} -r
	echo none > trigger
	/bin/umount ${SOURCE}	
	/media/hd/scripts/nma.sh SD2GlaDoS CopyImages Finished 1
	#echo "Finished."
}
moveImages
