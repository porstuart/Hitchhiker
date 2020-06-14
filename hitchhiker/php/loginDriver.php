<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);

$sql = "SELECT * FROM driver WHERE email = '$email' AND password = '$passwordsha' AND verify ='1' AND status = 'Approved' AND blacklist='whitelisted'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["email"].",".$row["fName"].",".$row["lName"].",".$row["matric"].",".$row["phoneNum"].",".$row["residentialHall"].",".$row["carBrand"].",".$row["carModel"].",".$row["carPlate"].",".$row["tripCount"];
    }
}else{
    echo "failed,null,null,null,null,null";
}