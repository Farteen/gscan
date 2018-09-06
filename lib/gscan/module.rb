require 'fastlane_core/helper'
require 'fastlane/boolean'
# require_relative 'detect_values'

module GScan
    class << self
        # Module attributes
        attr_accessor :config, :project, :cache, :devices
        # Virtual Attribute
        def config=(value)
            @config = value
            DetectValues.set_addtional_default_values
            @cache = {}
        end

        def scanfile_name
            "Scanfile"
        end
    end

    Helper = FastlaneCore::Helper
    UI = FastlaneCore::UI
    Boolean = Fastlane::Boolean
    # define ROOT path
    ROOT = Pathname.new(File.expand_path('../../..', __FILE__))
    DESCRIPTION = "learning fastlane scan"
end

