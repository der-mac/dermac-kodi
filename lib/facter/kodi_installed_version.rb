# Fact: kodi_installed_version
#
# Purpose:
#   Returns the version-number for the actualy installed kodi
#
# Resolution:
#   Windows:
#     Uses the powershell to read the versionnumber from the kodi.exe-file
#
# Caveats:
#   currently only windows 7 and windows 10

Facter.add(:kodi_installed_version) do
  setcode do
    command = 'powershell -noprofile -command "[System.Diagnostics.FileVersionInfo]::GetVersionInfo(\'C:\Program Files (x86)\Kodi\Kodi.exe\').FileVersion"'

    if Facter.value(:kernel) == 'windows'
      if name = Facter::Core::Execution.exec(command) and name =~ /([0-9\.]+)/
        return_value = $1
      end
    else
      return_value = 'not-windows'
    end
  end
end
