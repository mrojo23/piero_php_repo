<?php

function  chequearAno($fecha, $conexion)
{
   /* output : aYear (ID_Year, [ok|warning|error], error message)
   *
   */

   $ano = date('Y',strtotime($fecha));
   $consulta = "SELECT ID, Estado FROM TAno WHERE Ano = $ano";
   $aYear  = array('ID' => 0,'error' => 0,'error_msg' => 'ano:');
   
   if($ejecutar_consulta = $conexion->query(utf8_encode($consulta)))
   {
       // depurar aqui
      if($ejecutar_consulta->num_rows == 1)
      {
         $registro = $ejecutar_consulta->fetch_assoc();
         $aYear['ID']=$registro["ID"];
         $ano_estado = $registro["Estado"];
         
         if (!$ano_estado)
         {
           $aYear['error'] = -2; //warning
           $aYear['error_msg'] .= "<br>Warning: El <b>$ano</b> esta cerrado";
         }
         
      }
      else
      {
         $aYear['error'] = -1; //error
         $aYear['error_msg'] .= "<br>El anyo <b> $ano </b> no esta dado de alta en la Base de Datos";
         
      }//end if num_rows

      $ejecutar_consulta->close();

    }//fin if $ejecutar_consulta

    return $aYear;

} //fin chequearAno  


function  chequearCliente($num_cliente,$conexion)
{
 /* output : aYear (ID_Year, [ok|warning|error], error message)
   *
   */

   $consulta="SELECT ID FROM TClientes WHERE CustomerNumber = '$num_cliente'";
   
   $aCliente  = array('ID' => 0,'exist' => 0 ,'error_msg' => '');
   
   if($ejecutar_consulta = $conexion->query(utf8_encode($consulta)))
   {
      $aCliente['exist'] = $ejecutar_consulta->num_rows;

      $aCliente['error_msg'] .= "<br> cliente num_rows = ".$ejecutar_consulta->num_rows; 
      
      if($aCliente['exist']== 1)
      {
         $registro = $ejecutar_consulta->fetch_assoc();
         $aCliente['ID']=$registro["ID"];
         $aCliente['error_msg'] .= " ID_Cliente ".$aCliente['ID'];
      }

      $ejecutar_consulta->close();
    }
    else
    {
      $aCliente['error_msg'] .= "<br> Error en chequearCliente ejecutar_consulta!"; 

    }//fin if $ejecutar_consulta
    
    return $aCliente;
} // fin  chequearCliente 




function  chequearSemana ($fecha, $conexion)
{
  /*
  * output : aSemana (ID_Semana, [ok|warning|error], error message)
  *  
  */

   $aSenana  = array('ID' => 0, 'error' => 0,'error_msg' => '');
  
   $aYear = chequearAno ($fecha, $conexion);
   $aSenana['error_msg'] .= $aYear['error_msg'];
  
   if ($aYear['error'] != 0)
   {
       $aSenana['error'].= $aYear['error'];
       $aSenana['error_msg'] .= $aYear['error_msg'];
       if ($aYear['error'] == -1) return $aSenana;
    }

   $ID_ano = $aYear['ID'];
   $Nsemana = date('W',strtotime($fecha));
   $consulta = "SELECT ID, Estado FROM TSemana WHERE ID_ano = $ID_ano AND No_semana = $Nsemana";
   
   if($ejecutar_consulta = $conexion->query(utf8_encode($consulta)))
   {
	    if($ejecutar_consulta->num_rows == 1)
      {
         $registro = $ejecutar_consulta->fetch_assoc();
 
         $aSenana['ID']=$registro["ID"];
         $semana_estado=$registro["Estado"];
         $ano = date('Y',strtotime($fecha));

         switch ($semana_estado)
         {
	          case "-1":
	             $aSenana['error'] = -2; //warning
		           $aSenana['error_msg'].= "<br>Warning: La semana  <b>$Nsemana ($ano)</b> se considera obsoleta (estado = -1)";
		        break;
	          case "99":
	               $aSenana['error'] = -2; //warning
	               $aSenana['error_msg'] .= "<br>Warning: La semana  <b>$Nsemana ($ano)</b> se encuentra en el Futuro (estado = 99)";
	               $aSenana['error_msg'] .= "<br> El Cliente sera ignorado hasta su la fecha de Alta";         
		        break;
		        case "1":
		           $aSenana['error'] = 0; // no error
		           $aSenana['error_msg'] .= "Semena OK";
		        break;
		        case "0":
		           $aSenana['error'] = -2; //warning
		           $aSenana['error_msg'] .= "<br>Warning: La semana  <b>$Nsemana ($ano)</b> ya esta cerrada (estado = 0)";
		        break;
		        default:
                   $aSenana['error'] = -2; //warning
		               $aSenana['error_msg'] .= "<br>Warning: La semana  <b>$Nsemana ($ano)</b> Se encuentra en un estado desconocido ($semana_estado)";
		        break;
          }// fin switch semana estado
      }
      else
      {
      	 $aSenana['error'] = -1; //error
         $aSenana['error_msg'] .= "<br>La semana  <b>$Nsemana ($ano)</b> No esta dada de alta en la Base de Datos";
      }//fin if nunrows

      $ejecutar_consulta->close();
    }//fin if $ejecutar_consulta
    
    return $aSenana;   
}//fin function chequearSemana

?>