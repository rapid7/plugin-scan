module Stats::Writers
  class AddonWriter
    def write(document, visit)
      increment_addons(document, visit.hit)
      mark_outdated_addons(document, visit.failures)
    end

    private

    def increment_addons(document, hit)
      hit.each do |key, value|
        if is_addon?(key)
          addon = Addon.new(key, hit)
          increment_addon(document, addon)
          increment_addon_details(document, addon)
        end
      end
    end

    def mark_outdated_addons(document, failures)
      failures.each do |key, value|
        if is_addon?(key)
          addon = Addon.new(key, failures)
          mark_addon_details_as_outdated(document, addon)
        end
      end
    end

    def is_addon?(value)
      value.to_s.start_with?('ao_')
    end

    def increment_addon(document, addon)
      index = find_index_of_addon(document, addon.name)
      if index
        document.collection.find("_id" => document._id)
                           .update("$inc" => { "addons.#{index}.count" => 1 })
      else
        add_to_addons(document, addon)
      end
    end

    def find_index_of_addon(document, name)
      addons = document.read_attribute(:addons)
      if addons
        addons.index { |h| h['name'] == name }
      end 
    end

    def add_to_addons(document, addon)
      document.add_to_set(:addons, { 
        'name'    => addon.name, 
        'count'   => 1
      })
    end

    def increment_addon_details(document, addon)
      index = find_index_of_details(document, addon)
      if index
        document.collection.find("_id" => document._id)
                           .update("$inc" => { "#{addon.name}.#{index}.count" => 1 })
      else
        add_details(document, addon)
      end
    end

    def find_index_of_details(document, addon)
      details = document.read_attribute(addon.name.to_sym)
      if details
        details.index do |h|
          h['os'] == addon.os &&
          h['browser'] == addon.browser &&
          h['version'] == addon.version 
        end
      end 
    end

    def add_details(document, addon)
      document.add_to_set(addon.name.to_sym, {
        'os'       => addon.os,
        'browser'  => addon.browser,
        'version'  => addon.version,
        'count'    => 1,
        'outdated' => false
      })
    end

    def mark_addon_details_as_outdated(document, addon)
      index = find_index_of_details(document, addon)
      if index
        document.collection.find("_id" => document._id)
                           .update("$set" => { "#{addon.name}.#{index}.outdated" => true })
      end
    end

    class Addon
      def initialize(key, values)
        @key = key
        @values = values
      end

      def name
        str = @key.to_s
        str[3..str.size]
      end

      def os
        @values[:os]
      end

      def browser
        @values[:br]
      end

      def version
        version = @values[@key]
        version.gsub(/,/, '.')
      end
    end
  end
end
