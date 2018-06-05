# altimeter-docker
Docker Example for AltitudeCDN Altimeter Deployment

This repository contains a prototype Dockerfile and licensing procedure for AltitudeCDN Altimeter deployment.

Steps to build, run and license:

    1) docker build --build-arg ALT_PW=docker123 --build-arg MYSQL_PW=docker123 -t altimeter .

    2) docker run -d --name ALT_DOCKER_TEST -P -p 80:80 -p 443:443 altimeter:latest
    
    3) docker cp 8c217f45336f:/opt/altimeter-manager/license/8c217f45336f_0242AC110002-info.txt .
       docker cp 8c217f45336f:/opt/altimeter-manager/license/8c217f45336f_0242AC110002.req .
       
    4) submit request files to Ramp Customer Service to obtain production license

    5) docker cp ./lib/8c217f45336f_0242AC110002.bin 65fc0c1bb5f0:/opt/altimeter-manager/license/

    6) docker commit -m "update license" ALT_DOCKER_TEST altimeter_licensed

The 'altimeter' image container can now be stopped, and the new image 'altimeter_licensed' can be run.

