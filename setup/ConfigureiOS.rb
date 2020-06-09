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

      keep_demo = configurator.ask_with_answers("Would you like to include a demo application with your library", ["Yes", "No"]).to_sym
      
      snapshots = configurator.ask_with_answers("Would you like to do view based testing", ["Yes", "No"]).to_sym
      case snapshots
        when :yes
          configurator.add_pod_to_podfile "FBSnapshotTestCase"
          configurator.add_line_to_pch "@import FBSnapshotTestCase;"

          if keep_demo == :no
              puts " Putting demo application back in, you cannot do view tests without a host application."
              keep_demo = :yes
          end

          if framework == :specta
              configurator.add_pod_to_podfile "Expecta+Snapshots"
              configurator.add_line_to_pch "@import Expecta_Snapshots;"
          end
      end

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "templates/ios/PROJECT.xcodeproj",
        :platform => :ios,
        :remove_demo_project => (keep_demo == :no),
      }).run

      `mv ./templates/ios/* ./`
    end
  end

end
