#Provide for IOA 'Interface' Type

require 'puppet/provider/dell_iom'

Puppet::Type.type(:ioa_interface).provide :dell_iom, :parent => Puppet::Provider::Dell_iom do
  desc "Dell IOA provider for interface configuration."
  mk_resource_methods
  def initialize(device, *args)
    super
  end

  def self.lookup(device, name)
    if !name.nil?
      name=name.gsub(/te |tengigabitethernet /i, "TenGigabitEthernet ")
      name=name.gsub(/fo |fortygige /i, "fortyGigE ")
      name=name.gsub(/fc /i, "fibreChannel ")
      name=name.gsub(/po /i, 'Port-channel ')
    end
    device.switch.ioa_interface(name).params_to_hash
  end

  def flush
    device.switch.ioa_interface(name).update(former_properties, properties)
    super
  end
end
