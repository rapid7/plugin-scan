class SoftwareNames
  def get_full_name(name)
    to_hash[name] 
  end

  def to_hash
    {
      "dvr" => "Phoscode DevalVR",
      "flash" => "Adobe Flash",
      "java" => "Oracle Java",
      "qt" => "Apple Quicktime",
      "reader" => "Adobe Reader",
      "silver" => "Microsoft Silverlight",
      "rp" => "RealPlayer",
      "shock" => "Adobe Shockwave",
      "wmp" => "Windows Media Player",
      "vlc" => "VLC Player",
      "macintosh" => "Mac OS X",
      "linux" => "Linux (Other)",
      "ubuntu" => "Linux (Ubuntu)",
      "windows" => "Microsoft Windows",
      "chrome" => "Google Chrome",
      "chromium" => "Google Chromium",
      "firefox" => "Mozilla Firefox",
      "ie" => "Internet Explorer",
      "opera" => "Opera",
      "safari" => "Apple Safari",
      "unknown" => "Unknown"
    }
  end
end
