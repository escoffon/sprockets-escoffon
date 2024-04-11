require 'sprockets/exporters/base'

module Sprockets
  module Exporters
    # Writes a an asset file to disk
    class FileExporter < Exporters::Base
      def skip?(logger)
        if ::File.exist?(target)
          logger.debug "Skipping #{ target }, already exists"
          true
        else
          logger.info "Writing #{ target }"
          false
        end
      end

      def call
        begin
        print("++++++++++ FileExporter #{self} call - #{target}\n")
        write(target) do |file|
          file.write(asset.source)
        end
        print("  ++++++++ FileExporter #{self} call - did write\n")
        fstat = PathUtils.stat(target) # ++++ to catch it in a search
        print("  ++++++++ FileExporter #{self} call - stat: #{fstat}\n")
        print("  ++++++++ FileExporter #{self} call - ftype: #{fstat.ftype}\n") if !fstat.nil?
        rescue StandarError => exc
          print("  ++++++++ FileExporter #{self} call - exception: ${exc.message}\n")
          raise
        end
      end
    end
  end
end
