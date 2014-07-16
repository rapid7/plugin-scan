module PluginScan
  module Plugins
    class Parse < Struct.new(:params)
      def self.run(params)
        plugins = {}
        plugins[:ao_java] = params[:java]
        plugins[:ao_reader] = params[:ao_reader]
        plugins[:ao_dvr] = params[:ao_dvr]
        plugins[:ao_flash] = params[:ao_flash]
        plugins[:ao_java] = params[:ao_java]
        plugins[:ao_qt] = params[:ao_qt]
        plugins[:ao_rp] = params[:ao_rp]
        plugins[:ao_shock] = params[:ao_shock]
        plugins[:ao_silver] = params[:ao_silver]
        plugins[:ao_wmp] = params[:ao_wmp]
        plugins[:ao_vlc] = params[:ao_vlc]
        return plugins
      end

    end

  end
end

