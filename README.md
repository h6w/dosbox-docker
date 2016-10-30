# dosbox in a container

This Dockerfile will create an image from which you can run a dosbox container.
The dosbox config file is located in the /root/.dosbox/ volume, and the /dosbox volume will be where you write your data.
If you write anywhere but in those two directory (/dosbox and /root/.dosbox/) you will lose that data once you destroy the container.

## How to use it

You can start a dosbox container with those 2 commands:

``` xhost + ```

``` docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /path/on/your/system/data:/dosbox -v /path/on/your/system/config:/root/.dosbox tudorh/dosbox ```

- replace ``` /path/on/your/system/data ``` and ``` /path/on/your/system/config ``` with any directory on your system where you wish to store the data and config of dosbox.
- after dosbox is launched, type ``` MOUNT C /dosbox ``` in the prompt to mount your data volume in dosbox. (you can automate this by putting the mount command at the end of dosbox's config file)

## Notes
- When you are done using dosbox you should probably run ``` xhost - ``` to re-enable the access control to the X server.
- This will launch dosbox in a GUI so you can't run this without an X server.
