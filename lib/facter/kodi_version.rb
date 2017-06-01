# Fact: kodi_installed_version
#
# Purpose:
#   Gibt die Versionsnummer der aktuell installierten Kodi-Installation zurueck
#
# Resolution:
#   Windows:
#      Liest die Version der Kodi.exe Datei per Powershell aus
#
# Caveats:
#   Momentan nur Windows

Facter.add(:kodi_installed_version) do
  setcode do
    command = 'powershell -noprofile -command "[System.Diagnostics.FileVersionInfo]::GetVersionInfo(\'C:\Program Files (x86)\Kodi\Kodi.exe\').FileVersion"'

    if Facter.value(:kernel) == 'windows'
      if name = Facter::Core::Execution.exec(command) and name =~ /^([0-9\.]+)*$/
        return_value = $1
      end
    else
      return_value = 'not-windows'
    end
  end
end
