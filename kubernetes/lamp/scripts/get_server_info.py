import os
import xml.etree.ElementTree as ET

tree = ET.parse('/tmp/nodes_param.xml')
root = tree.getroot()

node_name=os.getenv('HOSTNAME')
temperatura=os.getenv('TEMPERATURA')
mem_act=os.getenv('MEMORIA_USATA')
mem_tot=os.getenv('MEMORIA_TOTALE')

for raspberry in root:

    print(raspberry.attrib['name'])

    if raspberry.attrib['name'] is node_name:
        raspberry[0].set(temperatura)
        raspberry[1].set(mem_act)
        raspberry[2].set(mem_tot)

tree.write('/tmp/nodes_param.xml')