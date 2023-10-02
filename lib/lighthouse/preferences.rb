module Lighthouse
  module Preferences
    class Error < StandardError; end
    class << self
      attr_writer :remote_debugging_port,
                  :lighthouse_cli,
                  :runner,
                  :lighthouse_options,
                  :chrome_flags
      attr_reader :remote_debugging_port

      def lighthouse_cli
        @lighthouse_cli ||= get_lighthouse_cli
      end

      def runner
        @runner ||= proc { |cmd| `npx #{cmd}` }
      end

      def lighthouse_options
        return unless @lighthouse_options
        return @lighthouse_options unless @lighthouse_options.is_a?(Array)

        @lighthouse_options.map { |f| "--#{f}" }.join(' ')
      end

      def chrome_flags
        return unless @chrome_flags
        return @chrome_flags unless @chrome_flags.is_a?(Array)

        @chrome_flags.map { |f| "--#{f}" }.join(' ')
      end

      private

      def get_lighthouse_cli
        system("npm install lighthouse") if lighthouse_bin_locator.nil?
        print("Lighthouse Version:")
        system("lighthouse --version")
        lighthouse_bin_locator
      end

      def lighthouse_bin_locator
        lighthouse_bin = `which lighthouse`
        lighthouse_bin.gsub!("\n", " ")
      end

    end
  end
end
