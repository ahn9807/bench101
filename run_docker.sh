#!/bin/bash

### Prepare docker
sudo service docker stop
# sudo cp -r /var/lib/docker ./docker_back
sudo rm -rf /var/lib/docker

### MOUNT NVMe
mkdir ./nvme_mnt
sudo mount /dev/nvme0n1 ./nvme_mnt

### softlink docker
sudo ln -s $(readlink -f ./)/nvme_mnt/docker /var/lib/docker
# sudo cp -r ./docker_back ./nvme_mnt/docker

### done!
sudo service docker start
