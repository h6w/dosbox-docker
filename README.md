# dosbox in a container

[![Microbadger](https://images.microbadger.com/badges/image/tudorh/dosbox.svg)](http://microbadger.com/images/tudorh/dosbox "Image size")
[![Docker Stars](https://img.shields.io/docker/stars/tudorh/dosbox.svg?maxAge=86400)](https://hub.docker.com/r/tudorh/dosbox/) 
[![Docker Pulls](https://img.shields.io/docker/pulls/tudorh/dosbox.svg?maxAge=86400)](https://hub.docker.com/r/tudorh/dosbox/)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=UY3DF5LBT46BE)

This Dockerfile will create an image from which you can run a dosbox container.
The dosbox config file is located in the /root/.dosbox/ volume, and the /dosbox volume will be where you write your data.
If you write anywhere but in those two directory (/dosbox and /root/.dosbox/) you will lose that data once you destroy the container.

There are currently 3 versions with matching docker hub tags:

* noaudio - Audio is disabled
* host-pulse - Use your host's pulseaudio 
* remote - Runs headless so you can connect via VNC/RDesktop  (In Progress - Probably available w/e March 31, 2017)

## How to use it

### Easy

1. Create a folder for dosbox in your home directory:

    ```
    mkdir $HOME/dosbox
    ```

1. Download the run script from here:
    * [run-noaudio](https://raw.githubusercontent.com/h6w/dosbox-docker/master/run-noaudio)
    * [run-hostpulse](https://raw.githubusercontent.com/h6w/dosbox-docker/master/run-hostpulse)

1. Make it executable:

    ```
    chmod a+x run-*
    ```

1. Run it:

    ```
    ./run-noaudio
    ```

NB: If you want to bypass the dosbox startup, you can optionally pass a command to the run script, e.g. `run-noaudio /bin/sh`


### Advanced

1. Allow your xhost to connect to the docker container

    ``` xhost +local:docker ```

1. Choose the appropriate options:

    1. Pick the image you need:
        * tudorh/dosbox:noaudio - for a local X without audio
        * tudorh/dosbox:hostpulse - for a local X with audio based on pulseaudio
        * tudorh/dosbox:remote - for a non-local X

    1. Specify a volume for dosbox

        ```
        -v /path/to/dosboxapp:/dosbox
        ```

    1. If you want to run on a local host's X display, you need:

        ```
        --env=DISPLAY=unix$DISPLAY
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro
        ```


    1. If you want to use your local host's pulseaudio, you need:
        * To get your local user ID and group ID:

            ```
            export USER_UID=$(id -u)
            export USER_GID=$(id -g)
            ```

        *  and pass that to the image:

            ```
            --env=USER_UID=$USER_UID
            --env=USER_GID=$USER_GID
            ```

        * And connect as that user and group id to pulseaudio:

            ```
            -v /dev/shm:/dev/shm
            -v $HOME/.config/pulse:/home/gamer/.config/pulse:ro
            -v /run/user/$USER_UID/pulse:/run/pulse:ro
            ```
	    
1. Put it all together:

    ```
    export USER_UID=$(id -u)
    export USER_GID=$(id -g)
    xhost +local:docker

    docker run -ti \
            --env=DISPLAY=unix$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
            --env=USER_UID=$USER_UID \
            --env=USER_GID=$USER_GID \
            -v /dev/shm:/dev/shm \
            -v $HOME/.config/pulse:/home/gamer/.config/pulse:ro \
            -v /run/user/$USER_UID/pulse:/run/pulse:ro \
            -v $HOME/dosbox:/dosbox \
            --name dosbox \
            tudorh/dosbox:hostpulse
    ```

## Using and configuring dosbox

- after dosbox is launched, type ``` MOUNT C /dosbox ``` in the prompt to mount your data volume in dosbox. (you can automate this by putting the mount command at the end of dosbox's config file)


## Notes
- When you are done using dosbox you should probably run ``` xhost -local:docker ``` to re-enable the access control to the X server.
