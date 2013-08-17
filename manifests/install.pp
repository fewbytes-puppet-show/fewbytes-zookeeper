class zookeeper::install(
	$url       = $zookeeper::params::url,
	$checksum  = $zookeeper::params::checksum,
	$version   = $zookeeper::params::version
) inherits zookeeper::params {
	file{"/opt/zookeeper":
		ensure => directory,
		mode => 644
	}
	->
	archive{"zookeeper-${version}":
		url => $url,
		digest_string => $checksum,
		target => "/opt/zookeeper"
	}
	->
	file{"/opt/zookeeper/current":
		ensure => link,
		target => "/opt/zookeeper/zookeeper-${version}"
	}
}