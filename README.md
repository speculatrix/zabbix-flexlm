# zabbix-flexlm

h1. A zabbix plugin for monitoring FlexLM licence usage

Instructions for installation

1 import the template into zabbix server

2 put this script into /opt/zabbix/bin and make it executable

3 create a file called /etc/zabbix_agentd.conf.d/flexlm_licence_usage.conf and make it contain the following three lines:
 UserParameter=flexlm.discovery,/opt/zabbix/bin/flexlm_licence_usage discovery
 UserParameter=flexlm.used[*],/opt/zabbix/bin/flexlm_licence_usage used $1
 UserParameter=flexlm.total[*],/opt/zabbix/bin/flexlm_licence_usage total $1

4 restart the zabbix agent


