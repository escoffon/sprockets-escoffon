require 'sprockets/exporters/base'
require 'sprockets/utils/gzip'

module Sprockets
  module Exporters
    # Generates a `.gz` file using the zlib algorithm built into
    # Ruby's standard library.
    class ZlibExporter < Exporters::Base
      def setup
        @gzip_target = "#{ target }.gz"
        @gzip = Sprockets::Utils::Gzip.new(asset, archiver: Utils::Gzip::ZlibArchiver)
      end

      def skip?(logger)
        return true if environment.skip_gzip?
        return true if @gzip.cannot_compress?
        if ::File.exist?(@gzip_target)
          logger.debug "Skipping #{ @gzip_target }, already exists"
          true
        else
          logger.info "Writing #{ @gzip_target }"
          false
        end
      end

      def call
        begin
        print("++++++++++ ZlibExporter call - #{target}\n")
        write(@gzip_target) do |file|
          @gzip.compress(file, target)
        end
        print("  ++++++++ ZlibExporter call - did write\n")
        fstat = PathUtils.stat(target) # ++++ to catch it in a search
        print("  ++++++++ ZlibExporter call - stat: #{fstat}\n")
        print("  ++++++++ ZlibExporter call - ftype: #{fstat.ftype}\n") if !fstat.nil? # ++++ to catch it in a search
        rescue StandarError => exc
          print("  ++++++++ ZlibExporter call - exception: ${exc.message}\n")
          raise
        end
      end
    end
  end
end
