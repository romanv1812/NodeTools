#!/bin/bash

EXTERNAL_IP=$(wget -qO- eth0.me)
NODE_NUMBER={{ NODE-NUMBER }}
NODE_HOME={{ NODE_HOME }}

echo $NODE_NUMBER
echo $NODE_HOME
