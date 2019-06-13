import sys
import xml.etree.ElementTree as ET

tree = ET.parse('/tmp/nodes_param.xml')
root = tree.getroot()

node_name=sys.argv[1]
temperatura=sys.argv[2]
mem_act=sys.argv[3]
mem_tot=sys.argv[4]

for raspberry in root:

    if raspberry.attrib['name'] == node_name:
        raspberry[0].text=temperatura
        raspberry[1].text=mem_act
        raspberry[2].text=mem_tot
tree.write(sys.stdout)
tree.write('/tmp/nodes_param.xml')