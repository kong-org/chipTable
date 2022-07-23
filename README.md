# chipTable
This is an on-chain interim solution to ERS. It will provide a simple chip lookup table for vendors. 

## Design
### Owner
Privileges:
- Can register TSMs
- Can add chipIds without needing signature

Data: 
- address

### TSM
Privileges:
- Can add chips with signature
- Can approve an operator to add chips for TSM

Data:
- tsmId: hash of the name (keccak(name))
- address: address that owns tsm
- operator: approved operator for tsm
- name: name of the tsm
- uri: redirect uri of the tsm

### Chip
Data: 
 - tsmId: maps the chip to a tsm

## .env
PRIVATE_KEY="<your_private_key>": Used for deploying
ALCHEMY_API_KEY="<your_alchemy_api_key>": Used for forking mainnet
COINMARKETCAP_KEY="<your_coinmarketcap_key>": Used for tracking gas prices
