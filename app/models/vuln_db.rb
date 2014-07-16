require 'ostruct'

class VulnDb
  @@db = nil

  def self.for(software, version)
    new(VulnProduct.new(software, version))
  end
  
  attr_reader :converter

  def initialize(converter)
    @converter = converter
  end

  def cves
    sorted_product_cves.collect do |cve| 
      OpenStruct.new(id: cve['cve_id'], summary: cve['summary'])
    end
  end

  def exploits
    cve_ids = cves.collect(&:id)
    { metasploit: exploits_for_metasploit(cve_ids),
      exploit_db: exploits_for_exploit_db(cve_ids) }
  end

  private

  def db
    if @@db.nil?
      serialized = File.read(VULN_DB_SOURCE)
      @@db = JSON.parse(serialized)
    end
    @@db
  end

  def sorted_product_cves
    product_cves.sort{ |a, b| b['cve_id'] <=> a['cve_id'] }
  end

  def product_cves
    db['cve'].select do |cve| 
      matches_company?(cve['company']) &&
      matches_product?(cve['product']) &&
      matches_version?(cve['versions'])
    end
  end

  def matches_company?(company)
    converter.companies.include? company
  end

  def matches_product?(product)
    converter.products.include? product
  end

  def matches_version?(versions)
    versions.compact.each do |version|
      padded_version = padded_with_zeros(version)
      return true if converter.version == padded_version
    end
    false
  end

  def padded_with_zeros(version)
    case version.scan(/\./).size
      when 2
        "#{version}.0"
      when 1
        "#{version}.0.0"
      else
        version
    end
  end

  def exploits_for_metasploit(related_cves)
    [].tap do |results|
      db['metasploit'].select do |exploit|
        if related_cves.include?(exploit['cve_id']) 
          results << OpenStruct.new(title: exploit['name'], fullname: exploit['fullname'])
        end
      end
    end
  end

  def exploits_for_exploit_db(related_cves)
    [].tap do |results|
      db['exploit_db'].select do |exploit|
        if related_cves.include?(exploit['cve_id']) 
          results << OpenStruct.new(title: exploit['description'], id: exploit['expdb_id'])
        end
      end
    end
  end
end
