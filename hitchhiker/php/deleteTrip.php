<?php
error_reporting(0);
include_once("dbconnect.php");
$tripID = $_POST['tripID'];
$sql     = "DELETE FROM trip WHERE tripID = $tripID";
    if ($conn->query($sql) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }

$conn->close();
?>