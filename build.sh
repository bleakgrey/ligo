clear
#meson build --prefix=/usr #GOBJECT_DEBUG=instance-count 
clear
cd build
ninja
./com.github.bleakgrey.ligo --debug
#./com.github.bleakgrey.ligo
