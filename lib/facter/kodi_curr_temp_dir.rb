# Fact: kodi_curr_temp_dir
#
# Purpose:
#   Returns the system-temp-directory for the actual user
#
# Resolution:
#   Uses the default windows environment variable %TEMP%
#
# Caveats:
#   currently only windows 7 and windows 10

Facter.add(:kodi_curr_temp_dir) do
  setcode do
    command = 'powershell -noprofile -command "echo $Env:TEMP"'

    if Facter.value(:kernel) == 'windows'
      if name = Facter::Core::Execution.exec(command) and name =~ /.*([a-zA-Z]:\\.*)$/
        return_value = $1
      end
    else
      return_value = 'not-windows'
    end
  end
end
