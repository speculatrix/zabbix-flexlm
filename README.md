# zabbix-flexlm

A zabbix plugin for monitoring FlexLM licence usage

## Instructions for installation

1 import the template into zabbix server


2 agent-side script
2.1 put the script into /opt/zabbix/bin and make it executable
2.2 tweak the agent-side script according to your installation of FlexLM and the location of the licence.dat file.



3 copy the .conf to /etc/zabbix_agentd.conf.d/flexlm_licence_usage.conf
 

4 restart the zabbix agent

