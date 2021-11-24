#!/bin/bash
###############  [CloudFlare DDNS] 授权信息（需修改成你自己的） ################ xiajibashe
# CloudFlare 注册邮箱
email="qq@email.com"
# CloudFlare Global API Key，
GAK="11231232132413241325qwdqer1312312345e"
# 做 DDNS 的根域名
zone_name="ym.com" 
# 更新的二级域名，如果想不用，直接填写根域名
record_name="www.ym.com"
# 域名类型，IPv4 为 A，IPv6 则是 AAAA
record_type="A"
# 是否代理dns解析 cdn加速。否：false 是：true。  dns页面的小云朵
proxy="false"


#获取IP地址
if [ $record_type = "A" ];then
    ip=`ifconfig | grep -A 2 ppp0 | grep inet\ addr | awk '{print $2}' | cut -c 6-`        
else
    ip=`ifconfig | grep -A 2 ppp0 | grep inet6 | awk '{print $3}' | cut -d '/' -f 1`     
fi


#start Get zone identifier
zone_id=`curl -ksX GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${GAK}" -H "Content-Type: application/json" | cut -b 19-50`
record_id=`curl -ksX GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${GAK}" -H "Content-Type: application/json" | cut -b 19-50`

#update
curl -ksX PUT "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${record_id}" -k -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${GAK}" -H "Content-Type: application/json" --data "{\"id\":\"$record_id\",\"type\":\"$record_type\",\"name\":\"$record_name\",\"content\":\"$ip\",\"proxied\":$proxy}"


#上传日记
logger -t "[CloudFlare]" "${record_name} : ${ip}"
echo "[CloudFlare]" "${record_name} : ${ip}"
