import jinja2
import subprocess
import argparse
import os
import sys

parser = argparse.ArgumentParser()
parser.add_argument('template', type=str)
parser.add_argument('out', type=str)
parser.add_argument('--OPENRAVE_BUILD_TYPE', type=str, default='Release')
parser.add_argument('--ROS_BUILD_TYPE', type=str, default='Release')
args = parser.parse_args()

templateabspath = os.path.abspath(args.template)
outabspath = os.path.abspath(args.out)

try:
    rootdir = subprocess.check_output('git rev-parse --show-toplevel', shell=True).rstrip()
except subprocess.CalledProcessError as e:
    print('Could not find git project root dir.')
    sys.exit(1)
os.chdir(rootdir)
packagexmls = filter(lambda line: line != '', subprocess.check_output('find . -name "package.xml" |grep -v ^openrave/package.xml$', shell=True).decode("utf-8").split('\n'))

commonpkgs_lines = []
catkinws_lines = []

for packagexml in packagexmls:
    if 'common_pkgs' in packagexml:
        commonpkgs_lines.append('COPY %s %s'%(packagexml, packagexml.replace('./common_pkgs', '/root/ros_catkin_ws/common_pkgs/src')))
    elif 'catkin_ws' in packagexml:
        catkinws_lines.append('COPY %s %s'%(packagexml, packagexml.replace('./catkin_ws', '/root/ros_catkin_ws/dev/src')))
commonpkgstext = '\n'.join(commonpkgs_lines)
catkinwstext = '\n'.join(catkinws_lines)


with open(templateabspath, 'r') as f:
    t = jinja2.Template(''.join(f.readlines()))
    replaced = t.render(COPY_COMMON_PKGS_PACKAGEXML_DEPENDENCIES=commonpkgstext,
            COPY_CATKIN_WS_PACKAGEXML_DEPENDENCIES=catkinwstext,
            OPENRAVE_BUILD_TYPE=args.OPENRAVE_BUILD_TYPE,
            ROS_BUILD_TYPE=args.ROS_BUILD_TYPE)

with open(outabspath, 'w') as f:
    f.write(replaced)
