# Fact: kodi_local_users
#
# Purpose:
#   Gibt ein Array aller lokalen Benutzer zurueck
#
# Resolution:
#   Windows:
#      Per WMI werden alle Benutzer ausgegeben, dann bereinigt und
#      als Array zurueckgegeben
#
# Caveats:
#   Momentan nur Windows

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
