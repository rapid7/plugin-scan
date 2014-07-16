require_relative 'version_scanner'

vers_scanner = VersionScanner.new
p vers_scanner.get_plugin_versions(:windows)