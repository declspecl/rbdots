# typed: strict
# frozen_string_literal: true

module Rbdots
    module DSL
        # Program configuration DSL interface
        class Programs
            extend T::Sig

            sig { params(programs_hash: T::Hash[Symbol, T.untyped]).void }
            def initialize(programs_hash)
                @programs = programs_hash
            end

            sig { params(block: T.nilable(T.proc.void)).void.checked(:never) }
            def zsh(&block)
                config = ProgramConfiguration.new
                config.instance_eval(&block) if block_given?
                @programs[:zsh] = config
            end

            sig { params(_block: T.nilable(T.proc.params(config: ProgramConfiguration).void)).void.checked(:never) }
            def bash(&_block)
                config = ProgramConfiguration.new
                yield(config) if block_given?
                @programs[:bash] = config
            end

            sig { params(block: T.nilable(T.proc.void)).void.checked(:never) }
            def git(&block)
                config = ProgramConfiguration.new
                config.instance_eval(&block) if block_given?
                @programs[:git] = config
            end

            sig { params(_block: T.nilable(T.proc.params(config: ProgramConfiguration).void)).void.checked(:never) }
            def vscode(&_block)
                config = ProgramConfiguration.new
                yield(config) if block_given?
                @programs[:vscode] = config
            end
        end

        # Configuration for a specific program
        class ProgramConfiguration
            extend T::Sig

            sig { returns(T::Hash[Symbol, T.untyped]) }
            attr_reader :options

            sig { void }
            def initialize
                @options = T.let({}, T::Hash[Symbol, T.untyped])
            end

            sig { params(enabled: T.nilable(T::Boolean)).void }
            def enable_completion(enabled: true)
                @options[:enable_completion] = enabled
            end

            sig { params(enabled: T.nilable(T::Boolean)).void }
            def enable_autosuggestion(enabled: true)
                @options[:enable_autosuggestion] = enabled
            end

            sig { params(enabled: T.nilable(T::Boolean)).void }
            def enable_syntax_highlighting(enabled: true)
                @options[:enable_syntax_highlighting] = enabled
            end

            sig { params(block: T.nilable(T.proc.void)).void.checked(:never) }
            def aliases(&block)
                aliases_config = AliasesConfiguration.new
                aliases_config.instance_eval(&block) if block_given?
                @options[:aliases] = aliases_config.to_hash
            end

            sig { params(script: String).void }
            def shell_init(script)
                @options[:shell_init] = script
            end

            sig { params(block: T.nilable(T.proc.void)).void.checked(:never) }
            def oh_my_zsh(&block)
                omz_config = OhMyZshConfiguration.new
                omz_config.instance_eval(&block) if block_given?
                @options[:oh_my_zsh] = omz_config.to_hash
            end

            sig { params(name: String).void }
            def user_name(name)
                @options[:user_name] = name
            end

            sig { params(email: String).void }
            def user_email(email)
                @options[:user_email] = email
            end

            sig { params(branch: String).void }
            def default_branch(branch)
                @options[:default_branch] = branch
            end

            sig { params(enabled: T.nilable(T::Boolean)).void }
            def pull_rebase(enabled: true)
                @options[:pull_rebase] = enabled
            end

            sig { params(vars: T::Hash[Symbol, T.untyped]).void }
            def environment_variables(vars)
                @options[:environment_variables] = vars
            end

            sig { params(key: Symbol, value: T.untyped).void }
            def set_option(key, value)
                @options[key] = value
            end

            sig { returns(T::Boolean) }
            def validate!
                true
            end
        end

        # Configuration for shell aliases
        class AliasesConfiguration
            extend T::Sig

            sig { returns(T::Hash[Symbol, T.untyped]) }
            attr_reader :aliases

            sig { void }
            def initialize
                @aliases = T.let({}, T::Hash[Symbol, T.untyped])
            end

            sig { params(name: Symbol, command: T.nilable(String)).void }
            def method_missing(name, command = nil)
                if command
                    @aliases[name] = command
                else
                    super
                end
            end

            sig { params(_name: Symbol, _include_private: T::Boolean).returns(T::Boolean) }
            def respond_to_missing?(_name, _include_private = false)
                true
            end

            sig { returns(T::Hash[Symbol, T.untyped]) }
            def to_hash
                @aliases
            end
        end

        # Configuration for Oh My Zsh
        class OhMyZshConfiguration
            extend T::Sig

            sig { returns(T::Hash[Symbol, T.untyped]) }
            attr_reader :config

            sig { void }
            def initialize
                @config = T.let({}, T::Hash[Symbol, T.untyped])
            end

            sig { params(enabled: T.nilable(T::Boolean)).void }
            def enable(enabled: true)
                @config[:enable] = enabled
            end

            sig { params(theme_name: String).void }
            def theme(theme_name)
                @config[:theme] = theme_name
            end

            sig { params(plugin_list: T::Array[String]).void }
            def plugins(plugin_list)
                @config[:plugins] = plugin_list
            end

            sig { params(config_text: String).void }
            def extra_config(config_text)
                @config[:extra_config] = config_text
            end

            sig { returns(T::Hash[Symbol, T.untyped]) }
            def to_hash
                @config
            end
        end
    end
end
