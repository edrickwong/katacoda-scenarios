install_loopback() {
    sudo apt update
    sudo apt -y install linux-headers-$(uname -r)
    sudo apt -y install linux-modules-extra-$(uname -r)
    sudo apt -y install dkms
    curl http://deb.debian.org/debian/pool/main/v/v4l2loopback/v4l2loopback-dkms_0.12.5-1_all.deb -o v4l2loopback-dkms_0.12.5-1_all.deb
    sudo dpkg -i v4l2loopback-dkms_0.12.5-1_all.deb
    sudo modprobe v4l2loopback exclusive_caps=1 video_nr=1,2
    sudo apt-get install -y libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-libav
}

setup_cameras() {
    mkdir camera-logs
    sudo gst-launch-1.0 -v videotestsrc pattern=ball ! "video/x-raw,width=640,height=480,framerate=10/1" ! avenc_mjpeg ! v4l2sink device=/dev/video1 > camera-logs/ball.log 2>&1 &
    sudo gst-launch-1.0 -v videotestsrc pattern=smpte horizontal-speed=1 ! "video/x-raw,width=640,height=480,framerate=10/1" ! avenc_mjpeg ! v4l2sink device=/dev/video2 > camera-logs/smpte.log 2>&1 &
}