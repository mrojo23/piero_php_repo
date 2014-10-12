<?php
 function fecha($ano,$Nsemana){
  $epoch = (($ano - 1970) *  31556926) + (($Nsemana - 1 ) * 604800 ) + 86400;//1 ener
  $lunes = $epoch - (date('N',$epoch) - 1) * 86400;// lunes anterior 
  return $lunes;
 } 

 echo date('d/m/Y',fecha(2014,1))." ".date('N',fecha(2014,1)) ;

?>