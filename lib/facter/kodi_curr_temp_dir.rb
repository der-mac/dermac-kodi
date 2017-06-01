# Fact: kodi_curr_temp_dir
#
# Purpose:
#   Gibt das fuer den aktuellen Benutzer gueltige System-Temp-Verzeichnis zurueck
#
# Resolution:
#   Verwendet auf Windows die Variable %TEMP%
#
# Caveats:
#   Momentan nur Windows

Facter.add(:kodi_curr_temp_dir) do
  setcode do
    command = 'powershell -noprofile -command "echo $Env:TEMP"'

    if Facter.value(:kernel) == 'windows'
      if name = Facter::Core::Execution.exec(command) and name =~ /^(.+)$/
        return_value = $1
      end
    else
      return_value = 'not-windows'
    end
  end
end
