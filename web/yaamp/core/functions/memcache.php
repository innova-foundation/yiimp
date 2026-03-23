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
