# zabbix-flexlm

h1. A zabbix plugin for monitoring FlexLM licence usage

Instructions for installation

# input the template into zabbix server
# put this script into /opt/zabbix/bin and make it executable
# create a file called /etc/zabbix_agentd.conf.d/flexlm_licence_usage.conf and make it contain the following three lines:
 UserParameter=flexlm.discovery,/opt/zabbix/bin/flexlm_licence_usage discovery
 UserParameter=flexlm.used[*],/opt/zabbix/bin/flexlm_licence_usage used $1
 UserParameter=flexlm.total[*],/opt/zabbix/bin/flexlm_licence_usage total $1

# restart the zabbix agent


