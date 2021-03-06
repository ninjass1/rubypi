# Get rubygems.
require 'rubygems'

# Get bundler.
require 'bundler'
Bundler.require :development

#
# UNIT TEST TASKS
#

# Load unit test framework. Error if it's not there.
gem 'test-unit'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.test_files = FileList['tests/test_suite*.rb']
end


#
# RELEASE TASKS
#


# Get releasy.
require 'releasy'

# Get the main RubyPI class to get the version number.
require_relative "ruby_pi.rb"

Releasy::Project.new do
  name "RubyPI"
  version RubyPI::VERSION
  verbose # Can be removed if you don't want to see all build messages.

  executable "ruby_pi.rb"
  
  files ["ruby_pi.rb",
         "model/*",
         "view/*",
         "controllers/*"]
  
  exposed_files ["README.md",
                 "LICENSE",
                 "COPYING",
                 "TODO.md",
                 "CHANGELOG.md"]
  
  add_link "http://www.github.com/andrewd18/rubypi", "RubyPI Github"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  # add_build :osx_app do
    # url "com.github.my_application"
    # wrapper "wrappers/gosu-mac-wrapper-0.7.41.tar.gz" # Assuming this is where you downloaded this file.
    # icon "media/icon.icns"
    # add_package :tar_gz
  # end

  # If building on a Windows machine, :windows_folder and/or :windows_installer are recommended.
  add_build :windows_folder do
    # icon "media/icon.ico"
    executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :exe # Windows self-extracting archive.
  end
end
