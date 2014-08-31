# Type for MXL Port-channel
# Parameters are
#     name - Port-channel name
# Properties are
#   desc - description for Port-channel
#   mtu - mtu value for Port-channel
#   shutdown - The shutdown flag of the Port-channel, true means Shutdown else no shutdown

Puppet::Type.newtype(:mxl_portchannel) do
  @doc = "This represents Dell MXL switch port-channel."

  apply_to_device

  ensurable

  newparam(:name) do
    desc "Port-channel name, represents Port-channel"
    isnamevar
    newvalues(/^\d+$/)

    validate do |value|
      return if value == :absent
      raise ArgumentError, "An invalid 'portchannel' value is entered. The 'portchannel' value must be between 1 and 128." unless value.to_i >=1 &&	value.to_i <= 128
    end

  end

  newproperty(:desc) do
    desc "Port-channel Description"
    newvalues(/^(\w\s*)*?$/)
  end

  newproperty(:mtu) do
    desc "MTU value"
    newvalues(/^\d+$/)

    validate do |value|
      return if value == :absent
      raise ArgumentError, "An invalid 'mtu' value is entered. The 'mtu' value must be between 594 and 12000." unless value.to_i >=594 && value.to_i <= 12000
    end
  end

  newproperty(:switchport) do
    desc "The switchport flag of the Port-channel, true mean move the port-channel to Layer2, else interface will be in Layer1"
    defaultto(:false)
    newvalues(:false,:true)
  end

  newproperty(:shutdown) do
    desc "The shutdown flag of the Port-channel, true means Shutdown else no shutdown"
    defaultto(:false)
    newvalues(:false,:true)
  end
  
  newproperty(:fcoe_map) do
    desc "fcoe map that needs to be associated with the port-channel"
    validate do |value|
      all_valid_characters = value =~ /^[A-Za-z0-9_]+$/
      raise ArgumentError, "Invalid fcoe-map name" unless all_valid_characters
    end
  end

end
