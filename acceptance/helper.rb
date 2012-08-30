module PuppetAcceptance
  module PuppetCommands

    # The default apply_manifest_on() method will not fail if a puppet --apply run has an error, as puppet will exit
    # with a 0 exit code. The --detailed-exitcodes switch will cause puppet to use specific exit codes to indicate that
    # an error occured during apply.
    def apply_manifest_catching_failures(host, manifest, options={}, &block)
      on_options = {:stdin => manifest + "\n"}
      on_options[:acceptable_exit_codes] = options.delete(:acceptable_exit_codes) if options.keys.include?(:acceptable_exit_codes)
      args = ["--verbose"]
      args << "--parseonly" if options[:parseonly]
      args << "--trace" if options[:trace]

      if options[:catch_failures]
        args << '--detailed-exitcodes'

        # From puppet help:
        # "... an exit code of '2' means there were changes, an exit code of '4' means there were
        # failures during the transaction, and an exit code of '6' means there were both
        # changes and failures."
        # We're after failures specifically so catch exit codes 4 and 6 only.
        on_options[:acceptable_exit_codes] = [0, 2]
      end

      args << { :environment => options[:environment]} if options.has_key?(:environment)

      on host, puppet_apply(*args), on_options, &block
    end
  end
end