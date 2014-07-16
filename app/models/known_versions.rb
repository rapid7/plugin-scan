class KnownVersions
  attr_reader :versions, :browser_fullname

  def initialize(os, browser, browser_fullname)
    @versions = VersionFinder.new(os, browser)
    @fullname = browser_fullname
  end

  def current
    software_versions(:current)
  end 

  def security
    software_versions(:security)
  end

  private

  def software_versions(category)
    {}.tap do |software|
      software[browser_fullname]        = versions.public_send(category, :br)
      software['Adobe Reader']          = versions.public_send(category, :reader)
      software['Phoscode DevalVR']      = versions.public_send(category, :dvr)
      software['Adobe Flash']           = versions.public_send(category, :flash)
      software['Oracle Java']           = versions.public_send(category, :java)
      software['Apple Quicktime']       = versions.public_send(category, :qt)
      software['RealPlayer']            = versions.public_send(category, :rp)
      software['Adobe Shockwave']       = versions.public_send(category, :shock)
      software['Microsoft Silverlight'] = versions.public_send(category, :silver)
      software['Windows Media Player']  = versions.public_send(category, :wmp)
      software['VLC Media Player']      = versions.public_send(category, :vlc)
    end.delete_if { |k,v| v.nil? }
  end
end
