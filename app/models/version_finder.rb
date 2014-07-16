class VersionFinder
  def initialize(os, browser)
    @os = os
    @browser = browser
  end

  def current(symbol) 
    version(to_key(symbol))
  end

  def security(symbol)
    version("#{to_key(symbol)}_s")
  end

  private

  def has_versions?
    SOFTWARE.has_key?(@os) && SOFTWARE[@os].has_key?(@browser)
  end

  def version(key)
    SOFTWARE[@os][@browser][key] if has_versions?
  end

  def to_key(symbol)
    case symbol 
      when :br
        'br_v'
      when :reader
        'ao_reader'
      when :dvr
        'ao_dvr'
      when :flash
        'ao_flash'
      when :java
        'ao_java'
      when :qt
        'ao_qt'
      when :rp
        'ao_rp'
      when :shock
        'ao_shock'
      when :silver
        'ao_silver'
      when :wmp
        'ao_wmp'
      when :vlc
        'ao_vlc'
    end
  end
end
