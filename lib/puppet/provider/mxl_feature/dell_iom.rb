#Provide for MXL 'VLAN' Type

require 'puppet/provider/dell_iom'

Puppet::Type.type(:mxl_vlan).provide :dell_iom, :parent => Puppet::Provider::Dell_iom do

  desc "Dell MXL switch provider for vlan configuration."

  mk_resource_methods
  def initialize(device, *args)
    super
  end

  def self.lookup(device, name)
    device.switch.feature(name).params_to_hash
  end

  def flush
    device.switch.feature(name).update(former_properties, properties)
    super
  end
end
