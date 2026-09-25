require 'xcodeproj'
require 'pathname'

ROOT = File.expand_path('..', __dir__)
SRC_ROOT = File.join(ROOT, 'BuildWithScience')
PROJECT_PATH = File.join(ROOT, 'BuildWithScience.xcodeproj')

project = Xcodeproj::Project.new(PROJECT_PATH)
main_group = project.main_group

target = project.new_target(:application, 'BuildWithScience', :ios, '17.0')

def add_files_recursively(project_group, fs_dir, target, exclude_dirs: [])
  Dir.entries(fs_dir).sort.each do |entry|
    next if entry.start_with?('.')
    full_path = File.join(fs_dir, entry)

    if File.directory?(full_path)
      if entry.end_with?('.xcassets')
        ref = project_group.new_reference(full_path)
        ref.set_source_tree('<group>')
        ref.name = entry
        target.resources_build_phase.add_file_reference(ref)
      else
        sub_group = project_group.new_group(entry, entry)
        add_files_recursively(sub_group, full_path, target)
      end
    else
      next unless entry.end_with?('.swift')
      ref = project_group.new_reference(full_path)
      ref.set_source_tree('<group>')
      ref.name = entry
      target.source_build_phase.add_file_reference(ref)
    end
  end
end

app_group = main_group.new_group('BuildWithScience', SRC_ROOT)
add_files_recursively(app_group, SRC_ROOT, target)

bundle_id = 'com.buildwithsciencelikeapp.app'

target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_id
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1'
  config.build_settings['SUPPORTS_MACCATALYST'] = 'NO'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
  config.build_settings['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] = 'AccentColor'
  config.build_settings['INFOPLIST_KEY_UILaunchScreen_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UISupportedInterfaceOrientations'] = 'UIInterfaceOrientationPortrait'
  config.build_settings['INFOPLIST_KEY_UIApplicationSceneManifest_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents'] = 'YES'
  config.build_settings['INFOPLIST_KEY_CFBundleDisplayName'] = 'Build With Science'
  config.build_settings['INFOPLIST_KEY_NSCameraUsageDescription'] = 'Build With Science uses your camera to take photos of meals so it can estimate nutrition and log progress photos.'
  config.build_settings['DEVELOPMENT_ASSET_PATHS'] = ''
  config.build_settings['ENABLE_PREVIEWS'] = 'YES'
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  config.build_settings['MARKETING_VERSION'] = '1.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
end

project.save
puts "Wrote #{PROJECT_PATH}"
