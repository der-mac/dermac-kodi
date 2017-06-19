# define: kodi::resource::userconfig
#
# This definition creates for the given user a
# specified configuration in its user-directory
#
# Parameters:
#   [*ensure*]                - Activates, or deactivates the configuration for the given user
#     (present|absent)
#   [*create_missing_user*]   - Creates the missing user, if it not present
#   [*missing_user_password*] - The password for the new user (if too simple, you get problems at login)
#   [*videodatabase_type*]    - Kodi video-database-type
#     (mysql|...), Default: ''
#   [*videodatabase_host*]    - Kodi video-database-server
#     Default: ''
#   [*videodatabase_port*]    - Kodi video-database-port
#     Default: 3306
#   [*videodatabase_user*]    - Kodi video-database-user
#     Default: 'kodi'
#   [*videodatabase_pass*]    - Kodi video-database-password
#     Default: ''
#   [*videodatabase_name*]    - Kodi video-database-name
#     Default: 'kodi_video'
#   [*musicdatabase_type*]    - Kodi video-database-type
#     (mysql|...), Default: ''
#   [*musicdatabase_host*]    - Kodi music-database-server
#     Default: ''
#   [*musicdatabase_port*]    - Kodi music-database-port
#     Default: 3306
#   [*musicdatabase_user*]    - Kodi music-database-user
#     Default: 'kodi'
#   [*musicdatabase_pass*]    - Kodi music-database-password
#     Default: ''
#   [*musicdatabase_name*]    - Kodi music-database-name
#     Default: 'kodi_music'
#   [*importwatchedstate*]    - Import previous exported playtimes and playcounters
#     Default: true
#   [*importresumepoint*]     - Import previous exported resume-points
#     Default: true
#
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  kodi::resource::userconfig { 'bob':
#    videodatabase_type => 'mysql',
#    videodatabase_host => '192.168.1.1',
#    musicdatabase_type => 'mysql',
#    musicdatabase_host => '192.168.1.1',
#  }
#

define kodi::resource::userconfig (
  $ensure                = present,
  $create_missing_user   = false,
  $missing_user_password = 'chang3_me',
  $videodatabase_type    = '',
  $videodatabase_host    = '',
  $videodatabase_port    = 3306,
  $videodatabase_user    = 'kodi',
  $videodatabase_pass    = 'kodi',
  $videodatabase_name    = 'kodi_video',
  $musicdatabase_type    = '',
  $musicdatabase_host    = '',
  $musicdatabase_port    = 3306,
  $musicdatabase_user    = 'kodi',
  $musicdatabase_pass    = 'kodi',
  $musicdatabase_name    = 'kodi_music',
  $importwatchedstate    = true,
  $importresumepoint     = true,
) {

  ## Set OS-specific-values
  case $::os['name'] {
    'windows': {
      $kodidata_dir  = "C:\\Users\\${name}\\AppData\\Roaming\\Kodi"
      $userdata_dir  = "${kodidata_dir}\\userdata"
      $adv_settings  = "${userdata_dir}\\advancedsettings.xml"
      $user_groups   = ['S-1-5-32-545']
      $user_password = $missing_user_password
    }
    'Fedora': {
      $kodidata_dir  = "/home/${name}/.kodi"
      $userdata_dir  = "${kodidata_dir}/userdata"
      $adv_settings  = "${userdata_dir}/advancedsettings.xml"
      $user_groups   = ['wheel']
      $user_password = pw_hash($missing_user_password, 'SHA-512', 'mysalt')
      #$user_password = '$1$h5YD4TR7$Jo.qY6yTXdGH8W9eTO3670'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }


  ## Check for various error conditions
  if ! ($name in $::kodi_local_users) {
    if ($create_missing_user == true) {
      user { "kodi_${name}":
        ensure     => present,
        name       => $name,
        managehome => true,
        groups     => $user_groups,
        password   => $user_password,
      }
    }
    else {
      fail("User ${name} not present on this host and \$create_missing_user is set to 'false'.")
    }
  }

  File {
    owner  => $name,
  }

  $ensure_file = $ensure ? {
    'absent' => absent,
    default  => file,
  }

  $ensure_dir = $ensure ? {
    'absent' => absent,
    default  => directory,
  }

  file { [$kodidata_dir, $userdata_dir] :
    ensure => $ensure_dir,
  }

  file { $adv_settings:
    ensure  => $ensure_file,
    content => template('kodi/advancedsettings.xml.erb'),
  }
}
