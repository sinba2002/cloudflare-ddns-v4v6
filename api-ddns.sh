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

##外网api
ipv4api="http://icanhazip.com"
ipv6api="https://api6.ipify.org/"

#获取IP地址
if [ $record_type = "A" ];then
    ip=`curl -ksG ${ipv4api}`        
else
    ip=`curl -ksG https://api6.ipify.org/`     
fi

#start Get zone identifier
zone_id=`curl -ksX GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${GAK}" -H "Content-Type: application/json" | cut -b 19-50`
record_id=`curl -ksX GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records" -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${GAK}" -H "Content-Type: application/json" | cut -b 19-50`

#update
curl -ksX PUT "https://api.cloudflare.com/client/v4/zones/${zone_id}/dns_records/${record_id}" -k -H "X-Auth-Email: ${email}" -H "X-Auth-Key: ${GAK}" -H "Content-Type: application/json" --data "{\"id\":\"$record_id\",\"type\":\"$record_type\",\"name\":\"$record_name\",\"content\":\"$ip\",\"proxied\":$proxy}"
echo "[CloudFlare]" "${record_name} : ${ip}"
