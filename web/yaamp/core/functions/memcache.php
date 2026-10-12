<?php

class YaampMemcache
{
	public $memcache = null;

	public function __construct()
	{
		if(!function_exists("memcache_connect")) return;
		$host = getenv('MEMCACHE_HOST') ?: '127.0.0.1';
		$this->memcache = @memcache_connect($host, 11211);
	}

	public function get($key)
	{
		if(!$this->memcache) return false;
		return @memcache_get($this->memcache, $key);
	}

	public function set($key, $value, $t=30, $options=0)
	{
		if(!$this->memcache) return;
		@memcache_set($this->memcache, $key, $value, $options, $t);
	}

	////////////////////////////////////////////////////////////////

	public function get_database_scalar($key, $query, $params=array(), $t=30)
	{
		$value = $this->get($key);
		if($value === false) {
			$value = dboscalar($query, $params);
			$this->set($key, $value, $t);
		}
		return $value;
	}

	public function get_database_column($key, $query, $params=array(), $t=30)
	{
		$value = $this->get($key);
		if($value === false) {
			$value = dbocolumn($query, $params);
			$this->set($key, $value, $t);
		}
		return $value;
	}

	public function get_database_count_ex($key, $table, $query, $params=array(), $t=30)
	{
		$value = $this->get($key);
		if($value === false) {
			$value = getdbocount($table, $query, $params);
			$this->set($key, $value, $t);
		}
		return $value;
	}

	public function get_database_list($key, $query, $params=array(), $t=30)
	{
		$value = $this->get($key);
		if($value === false) {
			$value = dbolist($query, $params);
			$flags = defined('MEMCACHE_COMPRESSED') ? MEMCACHE_COMPRESSED : 0;
		$this->set($key, $value, $t, $flags);
		}
		return $value;
	}

	public function get_database_row($key, $query, $params=array(), $t=30)
	{
		$value = $this->get($key);
		if($value === false) {
			$value = dborow($query, $params);
			$this->set($key, $value, $t);
		}
		return $value;
	}

	public function add_monitoring_function($name, $d1)
	{
		return;
	}
}

// File-backed memcache_* globals for hosts without the memcache extension.
if(!function_exists('memcache_connect'))
{
	function _yaamp_mc_file($key)
	{
		$dir = sys_get_temp_dir() . '/yaamp-memcache';
		if(!is_dir($dir)) @mkdir($dir, 0777, true);
		return $dir . '/' . preg_replace('/[^A-Za-z0-9_]/', '_', (string)$key) . '.dat';
	}

	function memcache_connect($host = '127.0.0.1', $port = 11211)
	{
		return new stdClass;
	}

	function memcache_get($memcache, $key)
	{
		$f = _yaamp_mc_file($key);
		if(!is_file($f)) return false;
		$raw = @file_get_contents($f);
		if($raw === false) return false;
		$d = @unserialize($raw);
		if(!is_array($d) || !array_key_exists('__val', $d)) return false;
		if(isset($d['__exp']) && $d['__exp'] > 0 && $d['__exp'] < time()) return false;
		return $d['__val'];
	}

	function memcache_set($memcache, $key, $value, $options = 0, $ttl = 0)
	{
		return @file_put_contents(_yaamp_mc_file($key), serialize(array(
			'__exp' => ($ttl ? time() + $ttl : 0),
			'__val' => $value,
		))) !== false;
	}

	function memcache_delete($memcache, $key)
	{
		@unlink(_yaamp_mc_file($key));
		return true;
	}
}
