<?php
include_once("fecha.php");
$ano="1";
$consulta="INSERT INTO tsemana (No_semana, ID_ano, Semana, Estado)<br>";
$Semana_actual = date("W");
echo "semana actual:$Semana_actual<br>";
for($Nsemana=1;$Nsemana<53;$Nsemana++)
{
	if($Nsemana<$Semana_actual)
	{
		$E="-1";//semana obsoleta "Null"
	}
	else if($Nsemana==$Semana_actual)
	{
		$E="1";//semana en curso //  0 semana cerrada
	}
    else
    {
    	$E="99";// no started week
    }
	
	$consulta.="(".$Nsemana." ,".$ano." ,'".date("d/m/Y",fecha(2014,$Nsemana))."' ,".$E." )";
	if($Nsemana==52)
	{
		$consulta.=";<br>";
	}
	else
	{
		$consulta.=",<br>";	
	}
}
echo "$consulta";
?>