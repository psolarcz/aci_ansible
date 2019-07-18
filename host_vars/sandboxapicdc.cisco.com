---

leafs:
  - id: 101
    name: ps_leaf_101
    interfaces:
      - id: 1/1
        lag_type: leaf
      - id: 1/2
        lag_type: leaf
  - id: 102
    name: ps_leaf_102
    interfaces:
      - id: 1/1
        lag_type: leaf
global:
  aaep: ps_aaep
  phys_dom: ps_phys_dom
  vlan_pool: ps_vlan_pool
  vlan_min: 100
  vlan_max: 200

interface_selector:
  - 
