class zookeeper::params{
	$url        = "http://www.us.apache.org/dist/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz"
	$checksum   = "f64fef86c0bf2e5e0484d19425b22dcb"
	$version    = "3.4.5"
	$user       = "zookeeper"
	$conf_dir   = "/etc/zookeeper"
	$data_dir   = "/var/lib/zookeeper"
	$log_dir    = "/var/log/zookeeper"
	$init_style = "sysv"
}