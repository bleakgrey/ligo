clear
#meson build --prefix=/usr #GOBJECT_DEBUG=instance-count 
clear
cd build
ninja
./com.github.bleakgrey.desidia --debug
#./com.github.bleakgrey.desidia
