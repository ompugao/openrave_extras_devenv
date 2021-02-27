import jinja2
import subprocess
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('template', type=str)
parser.add_argument('out', type=str)
args = parser.parse_args()


packagexmls = filter(lambda line: line != '', subprocess.check_output('find . -name "package.xml" |grep -v openrave/package.xml', shell=True).split('\n'))
lines = []

for packagexml in packagexmls:
    lines.append('COPY %s %s'%(packagexml, packagexml.replace('./common_pkgs', '/root/ros_catkin_ws/common_pkgs/src')))
text = '\n'.join(lines)


with open(args.template, 'r') as f:
    t = jinja2.Template(''.join(f.readlines()))
    replaced = t.render(COPY_PACKAGEXML_DEPENDENCIES=text)

with open(args.out, 'w') as f:
    f.write(replaced)
