class zookeeper::install(
	$url       = $zookeeper::params::url,
	$checksum  = $zookeeper::params::checksum,
	$version   = $zookeeper::params::version
) inherits zookeeper::params {
	if $url =~ /^puppet:\/\// {
		file {"/usr/src/zookeeper-$version.tar.gz":
			source => $url,
			before => Archive::Extract["zookeeper-${version}"]
		}
	} else {
		archive::download{"zookeeper-${version}":
			url => $url,
		    digest_string => $checksum,
		}
	}

	file{"/opt/zookeeper":
		ensure => directory,
		mode => 644
	}
	->
	archive::extract{"zookeeper-${version}":
		target => "/opt/zookeeper"
	}
	->
	file{"/opt/zookeeper/current":
		ensure => link,
		target => "/opt/zookeeper/zookeeper-${version}"
	}
}
