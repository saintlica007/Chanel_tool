import pandas as pd
import ipaddress

# 读取 IP 地址数据
query_data = pd.read_csv('query_data.csv')

# 读取 CIDR 范围数据
cidr_data = pd.read_csv('IP range-China.csv')

# 提取 IP 地址列和 CIDR 范围列
ip_addresses = query_data['clientIP_s']
cidr_ranges = cidr_data['CIDR']

# 定义函数：判断 IP 是否在任一 CIDR 范围内
def is_ip_in_cidr(ip, cidr_list):
    try:
        ip_addr = ipaddress.ip_address(ip)
        for cidr in cidr_list:
            print(cidr,ip_addr)
            if ip_addr in ipaddress.ip_network(cidr):
                return 'yes'
        return 'no'
    except ValueError:
        return 'no'

# 应用函数，生成新列
query_data['In CIDR Range'] = ip_addresses.apply(is_ip_in_cidr, args=(cidr_ranges,))

# 保存为 UTF-8 编码的 CSV 文件
query_data.to_csv('updated_query_data.csv', index=False, encoding='utf-8')
