require 'module'

module GScan
    class ErrorHandler
        class << self
            def handle_build_error(output)
                case output
                # Regular expression math
                when /US\-ASCII/
                    print("Your shell environment is not correctly configured")
                when /Testing Failed/
                    UI.build_failure!("")
                when /Executed/
                    return
                end
                UI.build_failure!("Error building/testing the application - see the log above")
            end
            
            private

            def print(text)
                UI.error(text)
            end
        end
    end
end
