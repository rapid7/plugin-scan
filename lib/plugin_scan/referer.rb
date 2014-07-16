module PluginScan
  class Referer < Struct.new(:referer)
    def self.detect(referer)
      ref = referer.headers['HTTP_REFERER'].to_s.strip
      return unless ref.length > 0
      URI.parse(ref).host rescue nil
    end
  end
end

