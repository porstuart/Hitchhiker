<?php
error_reporting(0);
include_once("dbconnect.php");
$tripID = $_POST['tripID'];
$email = $_POST['email'];

$sql = "UPDATE trip SET passenger_email = '$email' WHERE tripID = '$tripID'";
if ($conn->query($sql) === TRUE) {
    echo "success";
}else{
    echo "error";
}
$conn->close();
?>