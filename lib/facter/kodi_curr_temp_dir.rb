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
    if Facter.value(:kernel) == 'windows'
      command = 'powershell -noprofile -command "echo $Env:TEMP"'

      if name = Facter::Core::Execution.exec(command) and name =~ /.*([a-zA-Z]:\\.*)$/
        return_value = $1
      end
    elsif Facter.value(:kernel) == 'Linux'
      return_value = '/tmp'
    else 
      return_value = 'not-a-supported-os'
    end
  end
end
