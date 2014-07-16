class VulnProduct
  attr_reader :software, :version, :map

  def initialize(software, version)
    @software = software.downcase
    @version = version
    @map = build_map
  end

  def companies
    map.has_key?(software) ? map[software][:companies] : []
  end
 
  def products
    map.has_key?(software) ? map[software][:products] : []
  end

  private

  def build_map
    {
      'oracle java' => { companies: ['sun', 'oracle'], products: ['jdk', 'jre'] },
      'adobe flash' => { companies: ['macromedia'], products: ['flash', 'flash player'] },
      'adobe reader' => { companies: ['adobe'], products: ['reader', 'acrobat reader'] },
      'adobe shockwave' => { companies: ['adobe'], products: ['shockwave player'] },
      'apple quicktime' => { companies: ['apple'], products: ['quicktime'] },
      'realplayer' => { companies: ['realnetworks'], products: ['realplayer'] },
      'microsoft silverlight' => { companies: ['microsoft'], products: ['silverlight'] },
      'vlc player' => { companies: ['videolan'], products: ['vlc', 'vlc media player'] },
      'windows media player' => { companies: ['microsoft', 'windows'],
                                  products: ['windows media player', 'media player'] }
    }
  end
end
