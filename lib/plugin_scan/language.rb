module PluginScan
  class Language < Struct.new(:request)
    def self.detect(request)
      return unless request.headers['HTTP_ACCEPT_LANGUAGE']
      os_l, tmp = request.headers['HTTP_ACCEPT_LANGUAGE'].to_s.split(';')
      if os_l.to_s.length > 0
        os_l[0,1024].to_s
      end
    end
  end
end
