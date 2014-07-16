#!/usr/bin/env ruby
# Script to fetch new plugin version information from various sources and
# create a new candidate version of software_list.yml
#

require 'net/http'
require 'yaml'


HERE_DIR      = File.dirname(__FILE__)
CHANGE_LOG    = File.expand_path('changes.log',HERE_DIR)       # Logging information from run of script
CURR_VERSIONS = File.expand_path('software_list.yml',File.expand_path( "#{HERE_DIR}/../config") )      # The current software_list.yml.
NEW_VERSIONS  = File.expand_path('new.yaml',HERE_DIR)          # The versions as calculated during the script execution
NEXT_CURRENT  = File.expand_path('next-current.yaml',HERE_DIR) # The merged hash from the current and new yaml, a proposed new software_list.yml file.

# Dumps a timestamped block of text to our logging file.
#
def log_output(text)
  File.open(CHANGE_LOG, 'a') do |f|
    f.puts "#{Time.new.to_s} : #{text}"
  end
end

#noinspection RubyStringKeysInHashInspection,RubyUnusedLocalVariable
class VersionScanner

  class Agent
    # agents is hash, with the key being a symbol (one of :chrome,:chromium,:ie,:firefox)
    # and the value being the user-agent string.
    #
    def initialize(agents)
      @agents = agents
    end

    def get_agent(browser)
      @agents[browser]
    end

    def get_agents
      @agents
    end

  end

  class MacAgent < Agent
    def initialize
      super({
                :chrome  => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.91 Safari/537.11',
                :firefox => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Firefox/17.0',
                :safari  => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17'
            })
    end
  end


  class UbuntuAgent < Agent
    def initialize
      super({
                :chrome   => 'Mozilla/5.0 (X11; Ubuntu; Linux i686) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.91 Safari/537.11',
                :chromium => 'Mozilla/5.0 (X11; Ubuntu; Linux i686) AppleWebKit/537.4 (KHTML, like Gecko) Ubuntu/12.10 Chromium/22.0.1229.94 Chrome/22.0.1229.94 Safari/537.4',
                :firefox  => 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0'
            })
    end
  end

  class LinuxAgent < Agent
    def initialize
      super({
                :chrome   => 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.91 Safari/537.11',
                :chromium => 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.4 (KHTML, like Gecko) Ubuntu/12.10 Chromium/22.0.1229.94 Chrome/22.0.1229.94 Safari/537.4',
                :firefox  => 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0'
            })
    end
  end

  class WindowsAgent < Agent
    def initialize
      super({
                :ie      => 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)',
                :chrome  => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36',
                :firefox => 'Mozilla/5.0 (Windows NT 6.2; WOW64; rv:25.0) Gecko/20100101 Firefox/25.0',
                :safari  => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2'
            })
    end

  end

  def platforms
    @platforms.keys
  end
  def browsers
    @browsers
  end

  def initialize
    @platforms = {
        :linux   => VersionScanner::LinuxAgent.new,
        :ubuntu  => VersionScanner::UbuntuAgent.new,
        :mac     => VersionScanner::MacAgent.new,
        :windows => VersionScanner::WindowsAgent.new
    }
    @browsers = [
        :chrome,
        :chromium,
        :firefox,
        :ie,
        :safari
    ]
    @plugins= {

        'adobereader' => {
            :tag       => 'reader',
            :url       => 'http://get.adobe.com/reader/',
            :platforms => [:linux, :ubuntu, :mac, :windows],
            :regex     => {
                :mac     => /\s+mainInstallerName:\s*"Reader\s*(.*?)\s+/,
                :linux   => /\s+mainInstallerName:\s*"Reader\s*(.*?)\s+/,
                :ubuntu  => /\s+mainInstallerName:\s*"Reader\s*(.*?)\s+/,
                :windows => /\s+mainInstallerName:\s*"Reader\s*(.*?)\s+/
            },
            :eval => ->(platform,browser,version){
              # Reader had trouble with 11.0.2 on ie, reporting as 11.0.0
              res = version
              if  platform == :windows
                if browser == :ie
                  arr = version.split(',')
                  arr[2] = '0' if arr[2]
                  res = arr.join(',')
                else
                  res = '11,0,5' if version.split(',').slice(0,3).join(',') == '11,0,04'
                end
              end
              res
            }
        },
        'devalvr' => {
            :tag       => 'dvr',
            :url       => 'http://www.devalvr.com/scripts/version.js',
            :platforms => [:linux, :ubuntu, :mac, :windows],
            :regex     => /^var\s+versionpluginjs\s*=\s*'(.*?)'\s*;/
        },
        'flash' => {
            :tag       => 'flash',
            :url       => 'http://www.adobe.com/software/flash/about/',
            :platforms => [:linux, :ubuntu, :mac, :windows],
            :regex     => {
                :mac => {
                    :chrome   => /Macintosh.*?Chrome.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :safari   => /Macintosh.*?Safari.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :firefox  => /Macintosh.*?Firefox.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m
                },
                :linux => {
                    :firefox  => /Linux.*?Mozilla.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :chrome   => /Linux.*?Chrome.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :chromium => /Linux.*?Chrome.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m
                },
                :ubuntu => {
                    :firefox  => /Linux.*?Mozilla.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :chrome   => /Linux.*?Chrome.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :chromium => /Linux.*?Chrome.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m
                },
                :windows => {
                    :firefox => /Windows.*?Firefox.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :chrome  => /Windows.*?Chrome.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :ie      => /Windows.*?Internet\s+Explorer.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m,
                    :safari  => /Windows.*?Firefox.*?<\/td>[\r|\n]\s*<td>(.+?)<\/td/m
                }
            },
            :eval => ->(platform,browser,version){
              res = version
              if browser == :chrome
                # Chrome version is ahead of adobe.com/flash/about, we lie here and advance
                # the version.
                arr = version.split(',')
                arr[3] = '115' if arr[3] == '97' && arr[2] == '800'
                res = arr.join(',')
              end
              res
            }
        },
        'java' => {
            :tag => 'java',
            :url => 'http://www.java.com/en/download/manual.jsp',
            :platforms => [:linux, :ubuntu, :mac, :windows],
            :regex => /<strong>.*?Version\s+7\s+Update\s+([0-9]+?)\s*<\/strong>/,
            :eval  => ->(platform,browser,version){ "1,7,0,#{version}" }
        },
        'quicktime' => {
            :tag       => 'qt',
            # The URL below was extracted by observation of the http traffic to http://www.apple.com/quicktime/download
            # and by then finding where the version information was pulled from the apple servers. This is likely to
            # change in the future and when it does this URL will no longer be valid.
            #
            :url       => 'http://swdlp.apple.com/iframes/81/en_us/81_en_us.html',
            :platforms => [:mac, :windows],
            :regex     => /QuickTime\s+([0-9\.]+?)\s+for/
        },
        'realplayer' => {
            :tag       => 'rp',
            :url       => 'http://www.oldapps.com/Real.php',
            :platforms => [:linux, :ubuntu, :mac, :windows],
            :regex     => /Latest Version:.*?>Real\s+Player\s+([0-9\.]+?)\s*<\//
        },
        'shockwave' => {
            :tag       => 'shock',
            :url       => 'http://get.adobe.com/shockwave/',
            :platforms => [:mac, :windows],
            :regex     => {
                :mac     => /\s+<span\s+id="clientversion"\s*>(.*?)<.*?$/,
                :windows => /\s+<span\s+id="clientversion"\s*>(.*?)<.*?$/
            },
            :eval => ->(platform,browser,version){
                res = version
                if platform == :mac
                  # On windows, except for ie and on the mac it displays
                  # only the first 3 parts of the version with the last digit
                  # as 0.
                  arr = version.split(',')
                  arr[3] = '0' if arr[3]
                  res = arr.join(',')
                end
                res
              }
                     
        },
        'silverlight' => {
            :tag       => 'silver',
            :url       => 'http://www.microsoft.com/en-us/download/details.aspx?id=36946',
            :platforms => [:mac, :windows],
            :regex     => /Version:.*?[\r|\n].*?<span>([0-9\.]+?)<\/span>/m,
            :eval => ->(platform,browser,version){
              # Microsoft site does not list current silverlight version anywhere that I can find.
              # This is a manual update that needs to happen whenever silverlight changes.
              '5.1.20913.0'.gsub(/\./,',')
            }
        },
        'wmp' => {
            :tag       => 'wmp',
            :url       => {
                :windows => 'http://windows.microsoft.com/en-US/windows/download-windows-media-player',
                :mac     => 'http://www.microsoft.com/en-us/download/details.aspx?id=9442'
            },
            :platforms => [:mac, :windows],
            :regex     => //
        },
        'vlc' => {
            :tag       => 'vlc',
            :url       => 'http://www.videolan.org/vlc/index.html',
            :platforms => [:linux, :ubuntu, :mac, :windows],
            :regex     => {
                :mac     => /navigator.appVersion.indexOf\(\s*"Mac"\s*\).*?\n^\s+latestVersion\s*=\s*'(.*?)';/m,
                :linux   => /navigator.appVersion.indexOf\(\s*"Win"\s*\).*?\n^\s+latestVersion\s*=\s*'(.*?)';/m,
                :ubuntu  => /navigator.appVersion.indexOf\(\s*"Win"\s*\).*?\n^\s+latestVersion\s*=\s*'(.*?)';/m,
                :windows => /navigator.appVersion.indexOf\(\s*"Win"\s*\).*?\n^\s+latestVersion\s*=\s*'(.*?)';/m
            },
            :eval => ->(platform,browser,version){
              res = version
              if platform == :windows && version == '2,1,2'
                res = '2,1,0' unless browser == :ie
              end
              res
            }
        }

    }

  end

  #
  # For the given platform, attempt to look up version information for
  # each of the plugs for the platform. The returned value from the
  # function is a hash, with each of the browsers as the key and a
  # hash as the value. The 2nd level hash has the plugin name as the
  # key and the version as the value. If the plugin is not supported
  # on the platform/browser then the 2nd level hash value is an empty
  # string.
  #
  def get_plugin_versions(platform)
    ret = {}

    # Iterate over each of the plugins, seeing if the plugin
    # is supported on the passed platform.
    @plugins.each do |plugin, plugin_info|
      # If the platforms includes the passed platform, we'll get
      # the url and the collection of agent strings and determine
      # the version.
      if plugin_info[:platforms].include?(platform)
        url = plugin_info[:url]
        # If there are different urls depending on the platform, then
        # we'll resolve which url to use here.s
        if url.class.to_s == 'Hash'
          url = url[platform]
        end

        # Could be a single regex, or a hash that has regex's by platform
        # for some plugins.
        regex = plugin_info[:regex]
        if regex.class.to_s == 'Hash'
          regex = regex[platform]
        end

        agent = @platforms[platform]

        agent.get_agents.each do |browser, agent_string|
          local_regex = regex
          #
          # Could be a regex by browser in rare cases.
          #
          if regex.class.to_s == 'Hash'
            local_regex = regex[browser]
          end

          version = ''
          body = simple_http_fetch(url, agent_string)
          if body =~ local_regex
            if $1
              # Need to force encoding since some come back as ascii encoded or other
              # and don't get persisted in yaml in readable form.
              version = $1.force_encoding( 'UTF-8' )
            end
          end
          if ret[browser.to_s] == nil
            ret[browser.to_s] = {}
          end
          # Convert version with periods to commas.
          version.gsub!( /\./, ',' )
          # If there's some format string, then evaluate now
          version = plugin_info[:eval].(platform,browser,version) if plugin_info[:eval]

          # puts "#{browser.to_s}.#{plugin_info[:tag]} = #{version} class=#{version.class.to_s}"
          ret[browser.to_s]["ao_#{plugin_info[:tag]}"] = version
          ret[browser.to_s]["ao_#{plugin_info[:tag]}_s"] = version
          #
          # Log out the fetched htlm to a file if debug turned on.
          #
          if $DEBUG
            puts "Version check completed for Platform #{platform}, Browser: #{browser}, Plugin: #{plugin} URL: #{url} Version: #{version}"
            File.open("/tmp/#{platform}-#{browser}-#{plugin}.html", 'w') do |f|
              f.puts("URL: #{url}\n")
              f.puts(body)
            end
          end
        end
      end

    end
    ret
  end

  # Get the java6 version. Not a platform based version but global.
  #
  def get_java6_version
    ret = nil
    rx = /"Java SE Development Kit 6u([0-9]+?)"/m
    user_agent = @platforms[:linux].get_agent(:chrome)
    text = simple_http_fetch( 'http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-javase6-419409.html', user_agent )
    text.split("\n").each { |line|
      if rx =~ line
        ret = "1,6,0,#{$1}"
        break
      end
    }
    raise 'Java 6 current version could not be determined' unless ret
    ret
  end


private

  #
  # Given a url and a User-Agent header value, this function
  # will connect to the URL and fetch the content. The User-Agent
  # header is sent along with a fixed set of additional headers.
  #
  #
  # Returns the HTML body fetched from the URL as a String
  #
  # Exceptions thrown upon the following conditions:
  #   The URL could not be parsed to get the host, path
  #   The HTTP GET failed with a result other than 200
  #   The underlying Net::HTTP class throws an exception
  #
  def simple_http_fetch(url, user_agent)
    # To extract the host and path we have two regexes
    # we attempt.
    host_regex1 = /http:\/\/(.*?)\/(.*)$/
    host_regex2 = /http:\/\/(.*?)$/
    if url =~ host_regex1
      host = $1
      path = '/'+$2
    else
      if url =~ host_regex2
        host = $1
        path = '/'
      else
        raise "#{url} could not be parsed to extract host and path."
      end

    end

    puts "Making get request to #{host} at path #{path}, user-agent=#{user_agent}" if $DEBUG
    session = Net::HTTP.new(host)
    headers = {
        'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'accept-charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
        'accept-language' => 'en-US,en',
        'user-agent' => user_agent,
        'content-length' => '0',
        'connection' => 'keep-alive'
    }

    # Do initial get..
    result = session.get(path, headers)

    # Loop though resolving any redirects, occasionally more than one
    # redirect occurs.
    while %w(301 302 303 307).include?(result.code)
      new_path = result['location']
      puts "Redirected to new URL: #{new_path}" if $DEBUG
      # Fetch again with different path
      result = session.get(new_path, headers)
      puts "Redirect status is: #{result.code}" if $DEBUG
    end

    # Will only deal with HTTP OK
    raise "Fetch of #{url} failed with RC=#{result.code}" if result.code != '200'
    result.read_body
  end

end

  # Builds a hash tree with the current versions as found in various
  # places across the web. Returns the hash built from the web requests and
  # regex parsing.
  #
  def get_new_versions
    results = {}
    vers_scanner = VersionScanner.new
    results[ 'JAVA6' ]     = vers_scanner.get_java6_version
    results[ 'JAVA6_s' ]   = vers_scanner.get_java6_version
    results[ 'windows' ]   = vers_scanner.get_plugin_versions(:windows)
    results[ 'macintosh' ] = vers_scanner.get_plugin_versions(:mac)
    results[ 'linux' ]     = vers_scanner.get_plugin_versions(:linux)
    results[ 'ubuntu' ]    = vers_scanner.get_plugin_versions(:ubuntu)

    File.open( NEW_VERSIONS , 'w+' ) do | f |
      f.puts results.to_yaml
    end
    results

  end

  #
  # Reads the hash from the file name specified and returns the
  # hash read from that file.
  #
  #noinspection RubyResolve
def get_previous_versions( file )
    YAML::load( File.open( file ) )
  end

  # function takes the old hash for the versions, the new hash for
  # versions and merges the two. Any differences in the new are chosen
  # for the merge (but empty values in new are not used). The output
  # is placed into the pased merged_vers hash.
  #
  def merge_old_and_new( merged_vers, old_vers, new_vers )
    num_changes = 0
    old_vers.each do | key, val |
      if val.class.to_s == 'Hash'
        merged_vers[key] = {}
        puts "Merge: Recursing on key=#{key}"  if $DEBUG
        num_changes += merge_old_and_new( merged_vers[key], val, new_vers[key] )
      else
        val.gsub( /\./, ',')
        merged_vers[key] = val

        new_val = new_vers[key]
        if new_val && !new_val.empty?
          if new_val != val
            merged_vers[key] = new_val
            log_output( "Merge: Change occurred for key=#{key},  old value=#{val}, new value=#{new_val}")
            num_changes += 1
          end
        end
      end
    end
    num_changes
  end

#noinspection RubyResolve
def normalize_current
    curr = YAML.load( IO.read( CURR_VERSIONS ) )
    File.open( CURR_VERSIONS, 'w+' ) do | f |
      f.puts curr.to_yaml( { :SortKeys => true, :Indent=>4, :UseHeader=>true, :UseVersion=>true}  )
    end
  end


  # There are a handful of cases where the versions that are reported aren't usable
  # for some reason. For example the VLC is up to 2.0.5, but the javascript plugin is
  # reporting 2.0.2, except ie browser, for the version which would make the
  # customer think that they must install an update when the don't need to.
  #
  # This function is called after getting the versions from the web, and just prior to merging
  # into the existing hash tree. We can adjust the versions here so that these type of problems
  # can be addressed.
  #
  #noinspection SpellCheckingInspection
def handle_version_exceptions( new_versions )
    vscan = VersionScanner.new
    vscan.platforms.each do | platform |
      # The hash uses macintosh instead of mac, need to do a switch here so
      # that we can find the mac items.
      platform = :macintosh if platform == :mac
      if new_versions[platform.to_s]
        vscan.browsers.each do | browser |
          if new_versions[platform.to_s][browser.to_s]

            # On OSX, Quicktime is stuck at 7.7.1, even though the windows versions are ahead
            if platform == :macintosh
              new_versions[platform.to_s][browser.to_s]['ao_qt']   = '7,7,1' unless new_versions[platform.to_s][browser.to_s]['ao_qt'].empty?
              new_versions[platform.to_s][browser.to_s]['ao_qt_s'] = '7,7,1' unless new_versions[platform.to_s][browser.to_s]['ao_qt_s'].empty?
            end

          end

        end
      end
    end

  end

  # This function will update the software_list.yml file
  # commit the changes to git, then push the changes to the
  # staging heroku server.
  def put_changes_into_effect( perform_git_changes = false )
    `cp #{NEXT_CURRENT} #{CURR_VERSIONS}`

    if perform_git_changes
      log_output( 'Merging changes from master to local.')
      log_output( `git pull origin master` )

      log_output( 'Commiting changes to local git.' )
      log_output( `git add #{CURR_VERSIONS}`)
      log_output( `git commit -m "Version change via version_scanner script."`)
    end

  end

  def update_versions
    new_version   = get_new_versions
    handle_version_exceptions new_version

    curr_version  = get_previous_versions( CURR_VERSIONS )
    merged = {}
    num_changes = merge_old_and_new( merged, curr_version, new_version )

    # TODO:
    # Here is where the notification message should originate. If the num_changes is > 0, then
    # something relevant has changed and needs to be looked into.
    #
    File.open( NEXT_CURRENT, 'w+') do | f |
      f.puts merged.to_yaml
    end
    # Change single quotes to double quotes to match that of CURR_VERSIONS
    `sed --in-place s/\\'/\\"/g #{NEXT_CURRENT}`
    num_changes
  end

def check_for_updates
  begin
    raise "The current version yaml file (#{CURR_VERSIONS}) could not be found." unless File.exists?( CURR_VERSIONS )
    log_output('Starting version check.')
    num_changes = update_versions
    put_changes_into_effect( false )
    log_output("Completed version check, #{num_changes} changes found.")
  rescue Exception=>ex
    msg = "Failed version update, error=#{ex.to_s}"
    log_output( msg )
    puts msg
  ensure
    # Remove work files when all done.
    `rm -f #{NEW_VERSIONS} #{NEXT_CURRENT}`
  end
end

if $0 == __FILE__
  check_for_updates
end



