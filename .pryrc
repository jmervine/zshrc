#
# Misc Config
#
Pry.config.pager = true
Pry.config.color = true
Pry.config.history.should_save = true

#
# Prompt Hacks
#
if Readline::VERSION =~ /editline/i
  warn "Warning: Using Editline instead of Readline."
end

# wrap ANSI codes so Readline knows where the prompt ends
def colour(name, text)
  if Pry.color
    "\001#{Pry::Helpers::Text.send name, '{text}'}\002".sub '{text}', "\002#{text}\001"
  else
    text
  end
end

# pretty prompt
Pry.config.prompt = [
  proc { |target_self, nest_level, pry|
    prompt = colour :red, Pry.view_clip(target_self)
    prompt += ":#{nest_level}" if nest_level > 0
    prompt += colour :cyan, ' > '
  },
  proc { |target_self, nest_level, pry|
    subprompt = colour :red, "|"
    subprompt += colour :cyan, '> '
  }
]

# tell Readline when the window resizes
old_winch = trap 'WINCH' do
  if `stty size` =~ /\A(\d+) (\d+)\n\z/
    Readline.set_screen_size $1.to_i, $2.to_i
  end
  old_winch.call unless old_winch.nil?
end


#
# Aliases
#
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
Pry.commands.alias_command 'f', 'finish'
Pry.commands.alias_command 'cat', 'show-method'
Pry.commands.alias_command 'vi', 'edit-method'
Pry.commands.alias_command 'vim', 'edit-method'
Pry.commands.alias_command 'pwd', 'whereami'

#
# Editor
#
VIM = '/usr/bin/gvim -f'
Pry.editor = proc { |file, line| "#{VIM} #{file} +#{line}" }
#Pry.config.editor = "/usr/bin/gvim -f"

#
# Extras
#
Pry.config.commands.import Pry::ExtendedCommands::Experimental

#
# Toy Methods
# See https://gist.github.com/807492
#
class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end

#
# Random custom commands
#
Pry.commands.command(/!(\d+)/, "Replay a line of history, bash-style", :listing => "!hist") do |id|
  run "history --replay #{id}"
end

# Sed-style substitution for fixes in the current multi-line input buffer
Pry.commands.command(/s\/(.*?)\/(.*?)/)do |source, dest|
  eval_string.gsub!(/#{source}/) { dest }
  run 'show-input'
end

Pry.commands.command("version", "Show ruby version information", :listing => "version") do |id|
  puts "ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"
end
Pry.commands.alias_command 'ruby', 'version'

# vim:filetype=ruby
