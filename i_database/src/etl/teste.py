import json
import xmltodict

# Seu XML de exemplo
xml_data = '''
<root>
  <name>sa</name>
  <loginname>sa</loginname>
  <isntname>0</isntname>
  <sysadmin>1</sysadmin>
  <securityadmin>0</securityadmin>
  <serveradmin>0</serveradmin>
  <setupadmin>0</setupadmin>
  <processadmin>0</processadmin>
  <diskadmin>0</diskadmin>
  <dbcreator>0</dbcreator>
  <bulkadmin>0</bulkadmin>
</root>
'''

# Converter XML para dicionário
data_dict = xmltodict.parse(xml_data)

# Converter dicionário para JSON
json_data = json.dumps(data_dict, indent=2)

# Exibir o resultado
print(json_data)
