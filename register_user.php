<?php

if(!isset($_POST)){
  echo "failed ";
}


include_once("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);
$address = "na";
$sqlregister = "INSERT INTO `tbl_users`(`user_name`, `user_email`, `user_phone`, `user_address`, `user_password`, `user_otp`) 
                VALUES ('$name','$email','$phone','$address','$password', '$otp')";

if($conn->query($sqlregister)){
       $response = array('status' => 'success', 'data' => null);
       sendJsonResponse($response);
}else{
       $response = array('status' => 'failed', 'data' => null);
       sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>