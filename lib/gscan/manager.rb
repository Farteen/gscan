require 'fastlane_core/print_table'

require_relative 'module'
require_relative 'runner'

module GScan
    class Manager
        def work(options)
            Scan.config = options
            values = Scan.config.values(ask: false)
            values[:xcode_path] = File.expand_path("../..", FastlaneCore::Helper.xcode_path)
            FastlaneCore::PrintTable.print_values(
                config: values,
                hide_keys:[:destination, :slack_url],
                title: "Summary for gscan"
                )
            return Runner.new.run
        end

