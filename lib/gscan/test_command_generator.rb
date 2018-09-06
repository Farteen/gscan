require 'xcpretty_reporter_options_generator'

module GScan
    class TestCommandGenerator
        def generate
            parts = prefix
            parts << "env NSUnbufferedIO=YES xcodebuild"
            parts += options
            parts += actions
            parts += suffix
            parts += pipe

            parts
        end

        def prefix
            ["set -o pipfail &&"]
        end

        def project_path_array
            proj = GScan.project.xcodebuild_parameters
            return proj if proj.count > 0
            UI.user_error!("No project/workspace found")
        end

        def options
            config = GScan.config
             
            options = []
            options += project_path_array unless config[:xctestrun]
            options << "-sdk '#{config[:sdk]}'" if config[:sdk]
            options << destination 
            options << "-toolchain '#{config[:toolchain]}'" if config[:toolchain]
            options << "derivedDataPath '#{config[:derived_data_path]}'" if config[:derived_data_path]
            