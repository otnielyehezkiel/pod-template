module Pod

  class ConfigureIOS
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform

      use_tvlapplication = configurator.ask_with_answers("Would you like use TVLApplication?", ["Yes", "No"]).to_sym
      case use_tvlapplication
        when :yes
          configurator.add_pod_to_podfile "TVLApplication"
      end

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "templates/ios/PROJECT.xcodeproj",
        :platform => :ios,
        :use_tvlapplication => (use_tvlapplication == :yes),
        :remove_demo_project => false,
      }).run

      `mv ./templates/ios/* ./`
    end
  end

end
