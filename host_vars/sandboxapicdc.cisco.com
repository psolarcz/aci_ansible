---
apic_username: admin
apic_use_proxy: no
apic_validate_certs: no


aci_model_data:
  access_policy:
  - switch_policy_virtual_port_channel:
    - name: 997_998
      id: 997
      switch1: 997
      switch2: 998
  - switch_policy_profile:
    - name: POD1_Leaf101
      leaf_selector:
      - name: 101
        from: 101
        to: 101
      interface_selector_profile:
      - name: POD1_Leaf101
    - name: POD1_Leaf102
      leaf_selector:
      - name: 102
        from: 102
        to: 102
      interface_selector_profile:
      - name: POD1_Leaf102
    - name: POD1_Leaf101_102
      leaf_selector:
      - name: 101_102
        from: 101
        to: 102
      interface_selector_profile:
      - name: POD1_Leaf101_102
  - interface_policy_lldp:
    - name: POD1_LLDPon
      receive_state: yes
      transmit_state: yes
  - interface_policy_cdp:
    - name: POD1_CDPon
      adminSt: enabled
  - interface_policy_port_channel:
    - name: LACPactive
      mode: active
  - interface_policy_policy_group_vpc:
    - name: 99_router_01
      lldp: LLDPon
      port_channel: LACPactive
      aep: 99_router_01
  - interface_policy_policy_group_access:
    - name: POD1_CDP_ON_LLDP_ON
      lldp: POD1_LLDPon
      cdp: POD1_CDPon
      aep: POD1_AAEP
  - interface_policy_profile:
#    - name: leaf_997_998
#      interface_selector:
#      - name: Router01
#        int_card: 1
#        int_to: 22
#        int_from: 22
#        policy_group: 99_router_01
#        policy_group_type: accbundle
    - name: POD1_Leaf101
      interface_selector:
      - name: ESX01_vmnic2
        int_card: 1
        int_to: 16
        int_from: 16
        policy_group: POD1_CDP_ON_LLDP_ON
        policy_group_type: accportgrp
      - name: DCN-CAT4948-1__1_21
        int_card: 1
        int_to: 21
        int_from: 21
        policy_group: POD1_CDP_ON_LLDP_ON
        policy_group_type: accportgrp
    - name: POD1_Leaf102
      interface_selector:
      - name: ESX02_vmnic3
        int_card: 1
        int_to: 48
        int_from: 48
        policy_group: POD1_CDP_ON_LLDP_ON
        policy_group_type: accportgrp
      - name: DCN-CAT4948-1__1_5
        int_card: 1
        int_to: 5
        int_from: 5
        policy_group: POD1_CDP_ON_LLDP_ON
        policy_group_type: accportgrp
  - vlan_pool:
    - name: POD1_100-149_Static
      alloc: static
      encap_block:
      - from: 100
        to: 149
    - name: POD1_150-199_Dynamic
      alloc: dynamic
      encap_block:
      - from: 150
        to: 199
  - aep:
    - name: POD1_AAEP
      domain:
      - name: POD1_phyDomain
        type: phys
      - name: POD1_vSwitch
        type: vmm
  - external_routed_domain:
    - name: 99_router_01
      vlan_pool: 99_router_01
      vlan_pool_alloc: static
  - physical_domain:
    - name: POD1_phyDomain
      vlan_pool: POD1_100-149_Static
      vlan_pool_alloc: phys
  tenant:
  - name: POD1_TNT
    description: POD1_TNT_Configured by Ansible
    app:
    - name: Billing
      epg:
      - name: servers
        bd: servers_bd
        contract:
        - name: internet
          type: consumer
        - name: web_app
          type: consumer
        static_path:
        - pod: 1
          path: topology/pod-1/paths-997/pathep-[eth1/33]
          encap: vlan-101
          mode: regular
        - pod: 1
          path: topology/pod-1/paths-997/pathep-[eth1/34]
          encap: vlan-101
          mode: native
        domain:
        - name: POD1_vSwitch
          type: vmm
      - name: hosts
        bd: hosts_bd
        contract:
        - name: web_app
          type: provider
        static_path:
        - pod: 1
          path: topology/pod-1/paths-998/pathep-[eth1/35]
          encap: vlan-102
          mode: untagged
        domain:
        - name: POD1_vSwitch
          type: vmm
    bd:
    - name: servers_bd
      subnet:
      - name: 10.0.0.1
        mask: 24
        scope: private
      vrf: VRF1
    - name: hosts_bd
      subnet:
      - name: 192.168.201.1
        mask: 24
        scope: private
      vrf: VRF1
      l3out:
      - name: l3out
    vrf:
    - name: VRF1
    contract:
    - name: internet
      scope: tenant
      subject:
      - name: internet
        filter: default
    - name: web_app
      scope: tenant
      subject:
      - name: web_app
        filter: default
    protocol_policy:
    - ospf_interface:
      - name: router_01_
