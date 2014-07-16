class SoftwareSpecs
  attr_reader :full_name, :os

  def initialize(args)
    @full_name = args.fetch(:full_name)
    @version   = args.fetch(:version).gsub(",", ".")
    @os        = args.fetch(:os)
  end

  def version
    @version.gsub(",",".")
  end
end
