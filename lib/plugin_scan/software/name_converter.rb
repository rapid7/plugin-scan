module PluginScan
  module Software
    class NameConverter
      def as_symbol(name)
        case name.downcase
          when 'adobe reader'
            :ao_reader
          when 'phoscode devalvr'
            :ao_dvr
          when 'adobe flash'
            :ao_flash
          when 'oracle java'
            :ao_java
          when 'apple quicktime'
            :ao_qt
          when 'realplayer'
            :ao_rp
          when 'adobe shockwave'
            :ao_shock
          when 'microsoft silverlight'
            :ao_silver
          when 'windows media player'
            :ao_wmp
          when 'vlc media player'
            :ao_vlc
        end
      end
    end
  end
end
