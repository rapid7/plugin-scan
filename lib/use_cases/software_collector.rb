module UseCases
  class SoftwareCollector
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def collect
      info = gather_info
      @report = check_software(info)
      write_info(source.tid, @report)
    end

    def gather_info
      GatherHitInformation.new(source).gather
    end

    def check_software(info)
      SoftwareVersionsChecker.new(source).check(info)
    end

    def write_info(tid, report)
      UseCases::WritesSoftwareInformation.new.write(tid, report)
    end

    def outdated_versions
      @report.present? ? @report.outdated_versions : {}
    end
  end
end
