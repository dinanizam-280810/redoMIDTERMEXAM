<?php
error_reporting(0);
if(!isset($_GET)){
	$response=array('status'=>'failed', 'data' =>null);
	sendJsonResponse($response);
	die();
}
$userid=$_GET['userid'];
include_once("dbconnect.php");
$sqlloadBuyerProducts = "SELECT * FROM tbl_product WHERE userid = '$userid'";
$result = $conn->query($sqlloadBuyerProducts);
if ($result->num_rows > 0) {
    $productsarray["products"] = array();
while ($row = $result->fetch_assoc()) {
        $hslist = array();
        $hslist['hsid'] = $row['hsid'];
        $hslist['userid'] = $row['userid'];
		$hslist['hsname'] = $row['hsname'];
        $hslist['hsdesc'] = $row['hsdesc'];
        $hslist['hsprice'] = $row['hsprice'];
        $hslist['hsstate'] = $row['hsstate'];
        $hslist['hslocality'] = $row['hslocality'];
        $hslist['hslat'] = $row['hslat'];
        $hslist['hslong'] = $row['hslong'];
        $hslist['hsdate'] = $row['hsdate'];
        array_push($productsarray["products"],$hslist);
    }
    $response = array('status' => 'success', 'data' => $productsarray);
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
