<?php 
function  conectarse ()
{
	$servidor="localhost";
	$usuario="root";
	$password="paswdkk";
	$db="Piero_DBTest";

	$conectar= new mysqli($servidor,$usuario,$password,$db);
	return $conectar;
}
?>
