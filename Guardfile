require 'guard/plugin'
require 'shellwords'

# README:
# `guard -g tests` to run unit tests whenever a source file changes.
# `guard -g misc` for git status, bundle install whenever the Gemfile changes, and more.

module ::Guard
	class XCTest < ::Guard::Plugin
		def _setup
			scheme = "OS X Tests"
			xcodebuild_test_cmd = "xcodebuild -workspace Typhoon.xcworkspace/ -scheme '#{scheme}' test"
			@rspec_test_task = "#{xcodebuild_test_cmd} | xcpretty -tc"
			@simple_test_task = "#{xcodebuild_test_cmd} | xcpretty -sc"

		end

		def start
			_setup

			_run
		end

		def reload
			_run
		end

		def run_all
			_run
		end

		def run_on_change(paths)
			if paths == ["Guardfile"]
				# We just ran in #start, don't run again.
				return
			end

			_run(paths)
		end

		def _run(paths=[])
  			output = `#{@rspec_test_task}`

  			ansi_color_regex = /\u001b\[[;\d]*m/
			stripped = output.gsub(ansi_color_regex, '').strip

			if stripped.empty? || $?.success? == false
  				::Guard::Notifier.notify("Unable to build the project.", :image => :failed, :title => 'Build failed')
  				return
  			end

  			last_line = stripped.lines.last.strip
  			
  			# success = $?.success? # xcpretty doesn't return xcodebuild's exit code
  			# so do some horrible things instead
  			num_failed_regex = /(\d) failure/
  			number_failed = last_line.match(num_failed_regex)[1].to_i
  			success = (number_failed == 0)

  			if success
  				::Guard::Notifier.notify(last_line, :image => :success, :title => 'Tests passed')
  			else
  				::Guard::Notifier.notify(last_line, :image => :failed, :title => 'Tests failed')
  			end

  			puts output # need to preserve colors!
		end
	end

	class GitStatus < ::Guard::Plugin
		def start
			_run
		end

		# def reload
		# 	_run
		# end

		def run_all
			_run
		end

		def run_on_change(paths)
			if paths == ["Guardfile"]
				# We just ran in #start, don't run again.
				return
			end

			_run
		end

		def _run
			puts `git status` # tell git it can use colors, it assumes it cannot
		end
	end
end

group :tests do
	guard :xctest do
		watch /.*/
		ignore [/.git/, /xcuserdata/, %r{Tests/Pods/}, %r{Tests/Podfile.lock}, /.idea/, /build/]
	end
end

group :misc do
	guard :shell do
		watch /.*/ do |m|
			puts m[0] + " has changed."
		end	

		ignore [/.git/, /xcuserdata/, %r{Tests/Pods/}, %r{Tests/Podfile.lock}]
		ignore [/build/]
	end

	guard :bundler do
 	 watch('Gemfile')
	  # Uncomment next line if your Gemfile contains the `gemspec' command.
	  # watch(/^.+\.gemspec/)
	end

	guard :gitstatus do 
		watch /.*/

		ignore [/build/]
	end
end




