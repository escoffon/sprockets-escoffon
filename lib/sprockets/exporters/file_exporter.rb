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
        print("++++++++++ FileExporter call - #{target}\n")
        write(target) do |file|
          file.write(asset.source)
        end
        print("  ++++++++ FileExporter call - did write\n")
        print("  ++++++++ FileExporter call - stat: #{PathUtils.stat(target)}\n")
      end
    end
  end
end
