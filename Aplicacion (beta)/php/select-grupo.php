<?php
include_once("conexion.php");
$conexion = conectarse();
$consulta="SELECT * FROM tgroup ORDER BY Grupo";

if($ejecutar_consulta = $conexion->query($consulta))
{	

   while ($registro = $ejecutar_consulta->fetch_assoc()) 
   {
	   echo "<option value='".$registro["Grupo"]."'>".$registro["Grupo"]."</option>";
   }

   $ejecutar_consulta->close();

}//fin if $ejecutar_consulta

$conexion->close();

?>