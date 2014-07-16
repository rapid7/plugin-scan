source_file = if Rails.env.test?
                File.join("#{::Rails.root}", "spec", "fixtures", "software_list.yml")
              else
                File.join("#{::Rails.root}", "config", "software_list.yml")
              end
SOFTWARE = YAML.load_file(source_file)
