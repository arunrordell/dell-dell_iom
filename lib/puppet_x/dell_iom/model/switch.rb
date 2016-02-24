#This class represents the switch model which contains the switch resources.
require 'puppet_x/force10/model/base'
require 'puppet_x/force10/model/vlan'
require 'puppet_x/force10/model/feature'
require 'puppet_x/force10/model/fcoemap'
require 'puppet_x/force10/model/dcbmap'
require 'puppet_x/force10/model/uplinkstategroup'
require 'puppet_x/force10/model/generic_value'
require 'puppet_x/force10/model/interface'
require 'puppet_x/force10/model/portchannel'
require 'puppet_x/force10/model/quadmode'
require 'puppet_x/dell_iom/model'
require 'puppet_x/dell_iom/model/ioa_interface'
require 'puppet_x/dell_iom/model/ioa_mode'
require 'puppet_x/dell_iom/model/ioa_autolag'


class PuppetX::Dell_iom::Model::Switch < PuppetX::Force10::Model::Base

  attr_reader :params, :vlans
  def initialize(transport, facts)
    super
    # Initialize some defaults
    @params         ||= {}
    @vlans          ||= []
    @portchannels   ||= []
    # Register all needed Modules based on the available Facts
    register_modules
  end

  def mod_path_base
    'puppet_x/dell_iom/model/switch'
  end

  def mod_const_base
    PuppetX::Dell_iom::Model::Switch
  end

  def param_class
    PuppetX::Force10::Model::GenericValue
  end

  def register_modules
    register_new_module(:base)
  end

  def skip_params_to_hash
    [ :snmp, :archive ]
  end

  def interface(name)
    int = params[:interfaces].value.find { |int| int.name == name }
    int.evaluate_new_params
    int
  end

  [
    :vlan,
    :interface,
    :portchannel,
    :feature,
    :fcoemap,
    :dcbmap,
    :uplinkstategroup,
    :quadmode
  ].each do |key|
    define_method key.to_s do |name|
      # grp = params[key].value.find { |resourcegrp| resourcegrp.name == name }
      #if grp.nil?
        grp = PuppetX::Force10::Model.const_get(key.to_s.capitalize).new(transport, facts, {:name => name})
        #params[key].value << grp
      #end
      grp.evaluate_new_params
      return grp
    end
  end

  [
    :ioa_interface,
    :ioa_mode,
    :ioa_autolag
  ].each do |key|
    define_method key.to_s do |name|
      #grp = params[key].value.find { |resourcegrp| resourcegrp.name == name }
      #if grp.nil?
        grp = PuppetX::Dell_iom::Model.const_get(key.to_s.capitalize).new(transport, facts, {:name => name})
        #params[key].value << grp
      #end
      grp.evaluate_new_params
      return grp
    end
  end
end
