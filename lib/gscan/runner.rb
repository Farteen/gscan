require_relative 'slack_poster'
require_relative 'test_command_generator'
require_relative 'error_handler'

module GScan
    class Runner
        def initialize
            @test_command_generator = TestCommandGenerator.new
        end

        def run
            handle_results(test_app)
        end

        def test_app
            open_simulator_for_device(Scan.devices.first) if Scan.devices
            command = @test_command_generator.generate
            prefix_hash = [
                {
                    prefix: "Running Tests: "
                    block: proc do |value|
                        value.include?("Touching")
                    end
                }
            ]
            exit_status = 0
            FastlaneCore::CommandExecutor.execute(command: command,
                print_all: true,
                print_command: true,
                prefix: prefix_hash,
                loading: "Loading...",
                error: proc do |error_output}|
                    begin
                        exit_status = $?.exitstatus
                        ErrorHandler.handle_build_error(error_output)
                    rescue => exception
                        SlackPoster.new.run({
                            build_errors: 1
                        })
                        raise ex
                    end
                end)
            exit_status
        end

        def handle_results(tests_exit_status)
            result = TestResultParser.new.parse_result(test_results)
            SlackPoster.new.run(result)

            if result[:failures] > 0
                failures_str = result[:failures].to_s.red
            else
                failures_str = result[:failures].to_s.green
            end
            puts(Terminal::Table.new({
                title: "Test Results",
                rows: [
                    ["Number of tests", result[:tests]],
                    ["Number of failures", failures_str]
                ]
            }))
            puts("")

            copy_simulator_logs

            if result[:failures] > 0
                UI.test_failure!("Tests have failed")
            end

            unless tests_exit_status == 0
                UI.test_failure!("Test execution failed. Exit status: #{tests_exit_status}")
            end

            zip_build_products

            if !Helper.ci? && GScan.cache[:open_html_report_path]
                `open --hide '#{GScan.cache[:open_html_report_path]}''`
            end
        end

        def zip_build_products
            return unless GScan.config[:should_zip_build_products]

            derived_data_path = GScan.config[:derived_data_path]
            path = File.join(derived_data_path, "Build/Products")

            output_directory = File.absolute_path(GScan.config[:output_directory])
            output_path = File.join(output_directory, "build_products.zip")
            GScan.cache[:zip_build_products_path] = output_path

            UI.message("Zipping build products")
            FastlaneCore::Helper.zip_directory(path, output_path, content_only: true, print: false)
            UI.message("Successfully zipped build products: #{output_path}")
        end

        def test_results
            temp_junit_report = GScan.cache[:temp_junit_report]
            return File.read(temp_junit_report) if temp_junit_report && File.file?(temp_junit_report)

            UI.message("generating test results. this may take a while for large projects")
            reporter_options_generator = XCPrettyReporterOptionsGenerator.new(fales, [], [], "", false)
            reporter_options = reporter_options_generator.generate_reporter_options
            cmd = "cat #{@test_command_generator.xcodebuild_log_path.shellescape} | xcpretty #{reporter_options.join(' ')} &> /dev/null"
            system(cmd)
            File.read(GScan.cache[:temp_junit_report])
        end

        def copy_simulator_logs
            return unless GScan.config[:include_simulator_logs]

            UI.header("Collectiong system logs")
            GScan.devices.each do |device|
                log_identity = "#{device.name}_#{device.os_type}_#{device.os_version}"
                FastlaneCore::Simulator.copy_logs(device, log_identity, GScan.config[:output_directory])
            end
        end

        def open_simulator_for_device(device)
            return unless FastlaneCore::Env.truthy?('FASTLANE_EXPLICIT_OPEN_SIMULATOR')

            UI.message("Killing all running simulators")
            `killall Simulator &> /dev/null`

            Fastlane::Simulator.launch(device)
        end
    end

end