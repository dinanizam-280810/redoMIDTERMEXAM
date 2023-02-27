<?php
error_reporting(0);
 
 include_once("dbconnect.php");

 $userid = $_POST['userid'];
 $hsname = addslashes($_POST['hsname']);
 $hsdesc = addslashes($_POST['hsdesc']);
 $hsprice = $_POST['hsprice'];
 $hsstate = addslashes($_POST['hsstate']);
 $hslocality = addslashes($_POST['hslocality']);
 $hslat = $_POST['lat'];
 $hslong = $_POST['long'];
 $image=$_POST['image'];

 $sqlinsert = "INSERT INTO `tbl_product`(`hsid`, `userid`, `hsname`, `hsdesc`, `hsprice`, `hsstate`, `hslocality`, `hslat`, `hslong`) 
               VALUES ('$hsid','$userid','$hsname','$hsdesc','$hsprice','$hsstate','$hslocality','$hslat','$hslong')";

try{
   if ($conn->query($sqlinsert) === TRUE) {
	   $decoded_string= base64_decode($image);
     $filename = mysqli_insert_id($conn);
     $path = 'C:/Users/acer/xampp/htdocs/homestayraya/mobile/assets/productimages/'.$filename.'.png';
     file_put_contents($path, $decoded_string);
     $response = array('status' => 'success', 'data' => null);
     sendJsonResponse($response);
   } 
   else {
          $response = array('status' => 'failed', 'data' => null);
          sendJsonResponse($response);
         }
  }
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();

 function sendJsonResponse($sentArray)
  {
   header('Content-Type: application/json');
   echo json_encode($sentArray);
  }
?>