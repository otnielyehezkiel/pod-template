require 'xcodeproj'
require 'yaml'

module Pod

  class ProjectManipulator
    attr_reader :configurator, :xcodeproj_path, :platform, :remove_demo_target, :string_replacements

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @xcodeproj_path = options.fetch(:xcodeproj_path)
      @configurator = options.fetch(:configurator)
      @platform = options.fetch(:platform)
      @use_tvlapplication = options.fetch(:use_tvlapplication)
      @remove_demo_target = options.fetch(:remove_demo_project)
    end

    def run
      @string_replacements = {
        "PROJECT_OWNER" => @configurator.user_name,
        "TODAYS_DATE" => @configurator.date,
        "TODAYS_YEAR" => @configurator.year,
        "PROJECT" => @configurator.pod_name,
        "PROJECTRESOURCES" => @configurator.pod_name + "Resources"
      }
      replace_internal_project_settings

      @project = Xcodeproj::Project.open(@xcodeproj_path)
      add_podspec_metadata
      remove_demo_project if @remove_demo_target
      @project.save

      rename_files
      rename_project_folder
      add_swiftlint_metadata

      if @use_tvlapplication
        add_tvlapplication_to_appdelegate
      end
    end

    def add_tvlapplication_to_appdelegate
      app_delegate_path = project_folder + "/SandboxApp/AppDelegate.swift"

      if File.exists? app_delegate_path
        app_delegate_content = "
//
//  AppDelegate.swift
//  SandboxApp
//
//  Created by hendy.christianto on 09/03/20.
//  Copyright © 2020 Traveloka. All rights reserved.
//

// Add your module import here, ex: import Bus
import UIKit
import TVLApplication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TVLApplicationContract, TVLTabBarControllerDataSource, AppCoordinatorNavigationApi {
    var rootViewController: TVLTabBarController!
    var app: TVLApplicationManager!
    let applicationCoordinator = AppCoordinator()
    var window: UIWindow?

    override init() {
        super.init()

        app = TVLApplicationManager(contract: self, isProduction: false)
    }

    // MARK: - LifeCycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let canLaunch: Bool = self.app.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)

        applicationCoordinator.interModuleNavigator = self

        rootViewController = TVLTabBarController(dataSource: self)

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return canLaunch
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.app.applicationWillResignActive(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.app.applicationDidBecomeActive(application)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return self.app.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.app.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return self.app.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.app.applicationDidReceiveMemoryWarning(application)
    }

    // MARK: - TVLApplicationContract
    func respondsToRemoteNotification(withAPSPayload pushNotificationObject: [AnyHashable : Any]) {
        // Can be empty, implement if you want to enable remote notification
    }

    func registerForRemoteNotifications() {
        // Can be empty, implement if you want to enable remote notification
    }

    func resetNavigationControllers() {
        for navigationController in rootViewController.viewControllers ?? [] {
            guard let navController = navigationController as? TVLNavigationController else {
                continue
            }

            if navController.topViewController?.presentedViewController != nil {
                navController.topViewController?.dismiss(animated: false, completion: nil)
            }
            navController.popToRootViewController(animated: false)
        }
    }

    func activeNavigationController() -> TVLNavigationController {
        return rootViewController.viewControllers?[rootViewController.selectedIndex] as! TVLNavigationController
    }

    func appCoordinator() -> AppCoordinator {
        return applicationCoordinator
    }

    func navigationController(with type: TVLTabbarType) -> TVLNavigationController {
        self.resetNavigationControllers()

        return self.rootViewController.navigate(toTab: type)
    }

    func deeplinkRouters() -> [DeeplinkRouterProtocol] {
        return [
            // Put modular deeplink router here.
            // You can call DeeplinkManager.sharedInstance().openURL on applicationDidBecomeActive
            // after register the router here. It will act as the application entry
        ]
    }

    // MARK: - TVLTabBarControllerDataSource
    func provider(forTabBarType tabBarType: TVLTabbarType) -> TVLTabBarProvider! {
        return [
            TVLTabbarType.home: NoopTabProvider(),
            TVLTabbarType.myBooking: NoopTabProvider(),
            TVLTabbarType.inbox: NoopTabProvider(),
            TVLTabbarType.savedItems: NoopTabProvider(),
            TVLTabbarType.myAccount: NoopTabProvider(),
        ][tabBarType]!
    }

    // MARK: - AppCoordinatorNavigationApi
    // Please add the empty implementat of contract AppCoordinatorNavigationApi
    // Add implementation if you want to enable intermodule navigation.
    // But the module must be created first, so you can import the module on your SandboxApp.
    // If it's still on the legacy, you have to use Traveloka project
}"
        File.open(app_delegate_path, "w") { |file| file.puts app_delegate_content }
      else
        app_delegate_path_header = project_folder + "/SandboxApp/AppDelegate.h"
        app_delegate_path_impl = project_folder + "/SandboxApp/AppDelegate.m"
        return unless File.exists? app_delegate_path_header
        return unless File.exists? app_delegate_path_impl

        app_delegate_content_header = "
//
//  AppDelegate.h
//  SandboxApp
//
//  Created by hendy.christianto on 09/03/20.
//  Copyright © 2020 Traveloka. All rights reserved.
//

@import TVLApplication;

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, TVLApplicationContract, TVLTabBarControllerDataSource>

@property (nonatomic, strong) TVLApplicationManager *app;
@property (nonatomic, strong) AppCoordinator *appCoordinator;
@property (nonatomic, strong) UIWindow *window;

@end
"
        app_delegate_content_impl = "
//
//  AppDelegate.m
//  SandboxApp
//
//  Created by hendy.christianto on 09/03/20.
//  Copyright © 2020 Traveloka. All rights reserved.
//

#import \"AppDelegate.h\"

@interface AppDelegate () <AppCoordinatorNavigationApi>

@end

@implementation AppDelegate
@synthesize rootViewController;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.app = [[TVLApplicationManager alloc] initWithContract:self isProduction:NO];
    }
    return self;
}

#pragma mark - Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL canHandleDidFinishLaunching = [self.app application:application didFinishLaunchingWithOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.rootViewController = [[TVLTabBarController alloc] initWithDataSource:self];
    self.appCoordinator = [[AppCoordinator alloc] init];
    self.appCoordinator.interModuleNavigator = self;

    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];

    return canHandleDidFinishLaunching;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.app applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.app applicationDidBecomeActive:application];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [self.app application:app openURL:url options:options];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [self.app application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [self.app application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [self.app applicationDidReceiveMemoryWarning:application];
}

#pragma mark - TVLApplicationContract
- (void)resetNavigationControllers {
    TVLTabBarController *rootVC = self.rootViewController;
    for (TVLNavigationController *navigationController in rootVC.viewControllers) {
        if (navigationController.topViewController.presentedViewController) {
            [navigationController.topViewController dismissViewControllerAnimated:NO completion:nil];
        }
        [navigationController popToRootViewControllerAnimated:NO];
    }

    // Remove all active coordinators.
    [self.appCoordinator resetCoordinators];
}

- (TVLNavigationController *)activeNavigationController {
    TVLTabBarController *rootVC = self.rootViewController;
    return rootVC.viewControllers[rootVC.selectedIndex];
}

- (TVLNavigationController *)navigationControllerWithType:(TVLTabbarType)type {
    [self resetNavigationControllers];
    TVLTabBarController *rootVC = self.rootViewController;
    return [rootVC navigateToTab:type isFromDeeplink:YES];
}

- (NSArray<id<DeeplinkRouterProtocol>> *)deeplinkRouters {
    return @[
        // Put modular deeplink router here.
        // You can call [[DeeplinkManager sharedInstance] openURL:fromApp:] on applicationDidBecomeActive
        // after register the router here. It will act as the application entry
    ];
}

- (nonnull AppCoordinator *)appCoordinator {
    return _appCoordinator;
}


- (void)registerForRemoteNotifications {
    // Implement if you want to enable remote notificaion.
}

- (void)respondsToRemoteNotificationWithAPSPayload:(nonnull NSDictionary *)pushNotificationObject {
    // Implement if you want to enable remote notificaion.
}

#pragma mark - TVLTabBarControllerDataSource
- (id<TVLTabBarProvider>)providerForTabBarType:(TVLTabbarType)tabBarType {
    return @{
        @(TVLTabbarTypeHome): [NoopTabProvider class],
        @(TVLTabbarTypeMyBooking): [NoopTabProvider class],
        @(TVLTabbarTypeInbox): [NoopTabProvider class],
        @(TVLTabbarTypeSavedItems): [NoopTabProvider class],
        @(TVLTabbarTypeMyAccount): [NoopTabProvider class],
    }[@(tabBarType)];
}

#pragma mark - AppCoordinatorNavigationApi
// Please add the empty implementat of contract AppCoordinatorNavigationApi
// Add implementation if you want to enable intermodule navigation.
// But the module must be created first, so you can import the module on your SandboxApp.
// If it's still on the legacy, you have to use Traveloka project

@end"
        File.open(app_delegate_path_header, "w") { |file| file.puts app_delegate_content_header }
        File.open(app_delegate_path_impl, "w") { |file| file.puts app_delegate_content_impl }
      end
    end

    def add_podspec_metadata
      project_metadata_item = @project.root_object.main_group.children.select { |group| group.name == "Podspec Metadata" }.first
      project_metadata_item.new_file @configurator.pod_name  + ".podspec"
    end

    def remove_demo_project
      app_project = @project.native_targets.find { |target| target.product_type == "com.apple.product-type.application" }
      test_target = @project.native_targets.find { |target| target.product_type == "com.apple.product-type.bundle.unit-test" }
      test_target.name = @configurator.pod_name + "Tests"

      # Remove the implicit dependency on the app
      test_dependency = test_target.dependencies.first
      test_dependency.remove_from_project
      app_project.remove_from_project

      # Remove the build target on the unit tests
      test_target.build_configuration_list.build_configurations.each do |build_config|
        build_config.build_settings.delete "BUNDLE_LOADER"
      end

      # Remove the references in xcode
      project_app_group = @project.root_object.main_group.children.select { |group| group.display_name.end_with? "SandboxApp" }.first
      project_app_group.remove_from_project

      # Remove the product reference
      product = @project.products.select { |product| product.path == "SandboxApp.app" }.first
      product.remove_from_project

      # Remove the actual folder + files for both projects
      `rm -rf templates/ios/SandboxApp`
      `rm -rf templates/swift/SandboxApp`

      # Replace the Podfile with a simpler one with only one target
      podfile_path = project_folder + "/Podfile"
      podfile_text = <<-RUBY
${HEADER_PODS}

target '#{test_target.name}' do
  pod '#{@configurator.pod_name}', :path => '.'

  ${INCLUDED_PODS}
end
RUBY
      File.open(podfile_path, "w") { |file| file.puts podfile_text }
    end

    def project_folder
      File.dirname @xcodeproj_path
    end

    def rename_files
      # shared schemes have project specific names
      scheme_path = project_folder + "/PROJECT.xcodeproj/xcshareddata/xcschemes/"
      File.rename(scheme_path + "PROJECT.xcscheme", scheme_path +  @configurator.pod_name + ".xcscheme")

      # rename xcproject
      File.rename(project_folder + "/PROJECT.xcodeproj", project_folder + "/" +  @configurator.pod_name + ".xcodeproj")

      # rename umbrella header
      File.rename(project_folder + "/PROJECT/PROJECT.h", project_folder + "/PROJECT/" + @configurator.pod_name + ".h")

    end

    def rename_project_folder
      if Dir.exist? project_folder + "/PROJECT"
        File.rename(project_folder + "/PROJECT", project_folder + "/" + @configurator.pod_name)
      end

      if Dir.exist? project_folder + "/PROJECTResources"
        File.rename(project_folder + "/PROJECTResources", project_folder + "/" + @configurator.pod_name + "Resources")
      end
    end

    def add_swiftlint_metadata
      # Add swiftlint alias
      `ln -s ../../.swiftlint.yml ./.swiftlint.yml`

      # Add new included source paths to lint
      swiftlint = YAML.load_file(".swiftlint.yml")
      swiftlint["included"] << @configurator.pod_name
      swiftlint["excluded"] << @configurator.pod_name + "Tests"

      File.open(".swiftlint.yml", "w") { |file| file.write(swiftlint.to_yaml) }
    end

    def replace_internal_project_settings
      Dir.glob(project_folder + "/**/**/**/**").each do |name|
        next if Dir.exists? name
        text = File.read(name)

        for find, replace in @string_replacements
            text = text.gsub(find, replace)
        end

        File.open(name, "w") { |file| file.puts text }
      end
    end

  end

end
