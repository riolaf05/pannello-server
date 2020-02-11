from flask import Flask, Response, request
import subprocess
import os
import docker

app = Flask(__name__)

client = docker.APIClient(base_url='unix://var/run/docker.sock')

@app.route('/camera', methods = ['GET', 'POST', 'DELETE'])
def camera():
    if request.method == 'GET':

        volumes= ['/dev/bus/usb']
        volume_bindings = {
                            '/dev/bus/usb': {
                                'bind': '/dev/bus/usb',
                                'mode': 'rw',
                            },
        }
        host_config = client.create_host_config(
                            binds=volume_bindings,
                            privileged=True
        )
        
        devices=['/dev/vchiq:rwm']

        container = client.create_container(
                            image="rio05docker/obj_detection_cd:rpi3_rt_tflite_tpu",
                            name='ai-camera',
                            volumes=volumes,
                            host_config=host_config,
                            #environment=env,
        ) 

        response = client.start(container=container.get('Id'), devices=devices)
        return Response(response=response, status=200)
    

@app.route('/motion_sensor', methods = ['GET', 'POST', 'DELETE'])
def motion_sensor():
    if request.method == 'GET':
        """TODO"""
        return Response(response="command complete!", status=200)



@app.route('/light', methods = ['GET', 'POST', 'DELETE'])
def light():
    if request.method == 'GET':
        """TODO"""
        return Response(response="command complete!", status=200)



@app.route('/restart_minidlna', methods = ['GET', 'POST', 'DELETE'])
def restart_minidlna():
    if request.method == 'GET':
        """TODO"""
        return Response(response="command complete!", status=200)



@app.route('/ainews', methods = ['GET', 'POST', 'DELETE'])
def ainews():
    if request.method == 'GET':

        env=["TELEGRAM_BOT_TOKEN={}", "TELEGRAM_CHAT_ID={}".format(os.getenv('TELEGRAM_BOT_TOKEN'), os.getenv('TELEGRAM_CHAT_ID'))]
        '''
        volumes= ['/usr/bin/qemu-arm-static']
        volume_bindings = {
                            '/usr/bin/qemu-arm-static': {
                                'bind': '/usr/bin/qemu-arm-static',
                                'mode': 'rw',
                            },
        }
        host_config = client.create_host_config(
                            binds=volume_bindings
        )
        '''
        container = client.create_container(
                            image="rio05docker/ai_news_server:rpi3_develop_89714b6a3deaedd9672f73525ccc435cac5cd9ee",
                            name='ai-news',
                            #volumes=volumes,
                            #host_config=host_config,
                            environment=env,
        ) 

        response = client.start(container=container.get('Id'))
        return Response(response=response, status=200)



@app.route('/temperature', methods = ['GET'])
def temperature():
    if request.method == 'GET':
        stream = os.popen("/opt/vc/bin/vcgencmd measure_temp | sed 's/[^0-9|\.]*//g'")
        output = stream.read()
    return Response(response=output[:-1], status=200)



@app.route('/memory', methods = ['GET'])
def memory():
    if request.method == 'GET':
        stream = os.popen("df -h / | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\,]*//g'")
        output = stream.read()
    return Response(response=output[:-1], status=200)



@app.route('/harddisk', methods = ['GET'])
def harddisk():
    if request.method == 'GET':
        stream = os.popen("df -h /dev/sda1 | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\,]*//g'")
        output = stream.read()
    return Response(response=output[:-1], status=200)


if __name__ == '__main__':
     app.run(host='0.0.0.0', port='5002')