# == Class: kodi
#
# Installiert und konfiguriert die Anwendung Kodi-Mediaplayer (https://kodi.tv).
#
# === Parameters
#
# [*package_ensure*]
#   Paket installieren, oder entfernen
# [*$package_name*]
#   Name des Paketes im Betriebssystem
# [*$package_version*]
#   Kodi-Version, die installiert werden soll
# [*$download_link*]
#   Downloadlink fuer die Kodi-Version, die installiert werden soll
# [*$install_dir*]
#   Verzeichnis, in das Kodi installiert wird (Sollte nicht geaendert werden)
# [*$download_dir*]
#   Verzeichnis, in das die Installationsdatei heruntergeladen werden soll
# [*$destination_file*]
#   Name der heruntergeladenen Installationsdatei
# [*$download_cleanup*]
#   Soll die Installationsdatei entfernt wrden,
#   wenn die installierte Version gleich der gewuenschten Version ist
# [*$proxy_address*]
#   Proxy-Server fuer den Download der Installationsdatei
#   Siehe Doku zu download_module
# [*$proxy_user*]
#   Proxy-User fuer den Download der Installationsdatei
#   Siehe Doku zu download_module
# [*$proxy_password*]
#   ProxyPasswort fuer den Download der Installationsdatei
#   Siehe Doku zu download_module
# [*$is_password_secure*]
#   Boolean-Wert, der angibt, ob der Passwortstring secure ist
#   Siehe Doku zu download_module
#
# === Variables
#
# === Examples
#
#  class { 'kodi': }
#
# === Authors
#
# Martin Schneider <martin@dermac.de>
#
# === Copyright
#
# Copyright 2017 Martin Schneider
#
class kodi (
  $package_ensure     = $kodi::params::default_package_ensure,
  $package_name       = $kodi::params::default_package_name,
  $package_version    = $kodi::params::default_package_version,
  $install_dir        = $kodi::params::default_install_dir,
  $download_link      = $kodi::params::default_download_link,
  $download_dir       = $kodi::params::default_download_dir,
  $download_cleanup   = $kodi::params::default_download_cleanup,
  $destination_file   = $kodi::params::default_destination_file,
  $proxy_address      = $kodi::params::default_proxy_address,
  $proxy_user         = $kodi::params::default_proxy_user,
  $proxy_password     = $kodi::params::default_proxy_password,
  $is_password_secure = $kodi::params::default_is_password_secure,

) inherits kodi::params {

  validate_array($package_name)
  validate_string($package_version)
  validate_absolute_path($install_dir)
  validate_string($download_link)
  validate_absolute_path($download_dir)
  validate_bool($download_cleanup)
  validate_string($destination_file)
  validate_string($proxy_address)
  validate_string($proxy_user)
  validate_string($proxy_password)
  validate_bool($is_password_secure)


  anchor { 'kodi::begin': } ->
  class { '::kodi::install': } ->
  class { '::kodi::config': }
  anchor { 'kodi::end': }

}
