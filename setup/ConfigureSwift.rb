module Pod

  class ConfigureSwift
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform
      keep_demo = configurator.ask_with_answers("Would you like to include a demo application with your library", ["Yes", "No"]).to_sym

      if keep_demo == :yes
        use_tvlapplication = configurator.ask_with_answers("Would you like use TVLApplication?", ["Yes", "No"]).to_sym
        case use_tvlapplication
          when :yes
            configurator.add_pod_to_podfile "TVLApplication"
        end
      end

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "templates/swift/PROJECT.xcodeproj",
        :platform => :ios,
        :use_tvlapplication => (use_tvlapplication == :yes),
        :remove_demo_project => (keep_demo == :no),
        :prefix => ""
      }).run

      `mv ./templates/swift/* ./`
    end
  end

end
