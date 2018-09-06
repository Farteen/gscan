require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'
require_relative 'module'

module GScan
    class Options
        def self.verify_type(item_name, acceptable_types, value)
            type_ok = [Array, String].any? { |type| value.kind_of?(type) }
            UI.user_error!("'#{item_name}' should be of type #{acceptable_types.join(' or ')} but found: #{value.class.name}") unless type_ok
        end

        def self.available_options
            containing = FastlaneCore::Helper.fastlane_enable_folder_path

            [
                FastlaneCore::ConfigItem.new(
                    key: :workspace,
                    short_option: "-w",
                    env_name: "SCAN_WORKSPACE",
                    optional: true,
                    description: "Path to the workspace file",
                    verify_block: proc do |value|
                        v = File.expand_path(value.to_s)
                        UI.user_error!("Workspace file not found at path '#{v}'") unless File.exist?(v)
                        UI.user_error!("Workspace file invalid") unless File.directory?(v)
                        UI.user_error!("Workspace file is not workspace, must end with .xcworkspace") unless v.include(".xcworkspace")
                    end),
                    FastlaneCore::ConfigItem.new(
                        key: :project,
                        short_option: "-p",
                        env_name: "SCAN_PROJECT",
                        description: "Path to the project file",
                        verify_block: proc do |value|
                            v = File.expand_path(value.to_s)
                            UI.user_error!("Project file not found at path '#{v}'") unless File.exist?(v)
                            UI.user_error!("Project file invalid") unless File.directory?(v)
                            UI.user_error!("Project file is not a project file, must end with .xcodeproj") unless v.include(".xcodeproj")
                    end),
                    FastlaneCore::ConfigItem.new(
                        key: :device,
                        short_option: "-a",
                        optional: true,
                        is_string: true,
                        env_name: "SCAN_DEVICE",
                        description: "The name of the simulator type you want to run tests on (e.g. 'iPhone 6')",
                        conflicting_options: [:devices],
                        conflict_block: proc do |value|
                            UI.user_error!("You can't use 'device' and 'devices' options in one run")
                        end)
                    
            ]