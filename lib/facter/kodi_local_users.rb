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
  confine :kernel => 'windows'

  setcode do
    command = "wmic useraccount get name"

    users = Array.new
    Facter::Core::Execution.exec(command).each_line do |line|
      next if line.match(/^\s*$|^Name\s*$/)
      line =~ /^(\w+).*$/
      users << $1
    end
    users
  end
end
