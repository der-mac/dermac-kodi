# Fact: kodi_local_users
#
# Purpose:
#   Returns an array of all local users
#
# Resolution:
#   Windows:
#     Uses WMI to get all local users, sanitize them and returns them as an array
#
# Caveats:
#   currently only windows 7 and windows 10

Facter.add(:kodi_local_users) do
  setcode do
    if Facter.value(:kernel) == 'windows'
      command = "wmic useraccount get name"

      users = Array.new
      Facter::Core::Execution.exec(command).each_line do |line|
        next if line.match(/^\s*$|^Name\s*$/)
        line =~ /^(\w+).*$/
        users << $1
      end
      users
    elsif Facter.value(:kernel) == 'Linux'
      command = "cat /etc/passwd | awk -F: '{ print $1 }'"

      users = Array.new
      Facter::Core::Execution.exec(command).each_line do |line|
        next if line.match(/^\s*$|^Name\s*$/)
        line =~ /^(\w+).*$/
        users << $1
      end
      users
    else 
      return_value = 'not-a-supported-os'
    end
  end
end
