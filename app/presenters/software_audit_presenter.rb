require 'action_view'

class SoftwareAuditPresenter
  include ActionView::Helpers::TextHelper

  def self.for(software)
    new(software)
  end

  attr_reader :name, :audit, :website, :image

  def initialize(software)
    @name = software.name
    @audit = software.audit
    @website = PluginScan::Websites
    @image = PluginScan::Images
  end

  def image_tag
    image.render(name, 32)
  end

  def version
    audit[:detected].to_s.gsub(",", ".")
  end

  def current_version
    audit[:current].to_s.gsub(",", ".")
  end

  def update_available?
    ['Exploitable', 'Update'].include? audit[:status]
  end

  def download_url
    website.link(name)
  end

  def vulnerable?
    cve_urls.any?
  end

  def cve_urls
    audit[:cve_vulns].collect do |cve|
      id = cve.id.gsub('/', '-')
      shortened_summary = shorten_text(cve.summary)
      "<a href='http://cvedetails.com/cve/#{id}'>[#{id}] #{shortened_summary}</a>"
    end
  end

  def exploitable?
    metasploit_urls.any? || exploit_db_urls.any?
  end

  def metasploit_urls
    return [] if audit[:exploits].empty?
    audit[:exploits][:metasploit].collect do |exploit|
      title = shorten_text(exploit.title)
      "<a href='http://www.metasploit.com/modules/#{exploit.fullname}'>#{title}</a>"
    end
  end

  def exploit_db_urls
    return [] if audit[:exploits].empty?
    audit[:exploits][:exploit_db].collect do |exploit|
      title = shorten_text(exploit.title)
      "<a href='http://www.exploit-db.com/exploits/#{exploit.id}/'>#{exploit.title}</a>"
    end
  end

  def show_exploits_and_vulns?
    exploitable? || vulnerable?
  end
  
  private

  def shorten_text(text)
    truncate(text, :length => 50, :omission => '...')
  end
end
