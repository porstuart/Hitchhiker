<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];
$phoneNum = $_POST['phoneNum'];
$residentialHall = $_POST['residentialHall'];
$carBrand = $_POST['carBrand'];
$carModel = $_POST['carModel'];
$carPlate = $_POST['carPlate'];

$usersql = "SELECT * FROM driver WHERE email = '$email'";

if (isset($password) && (!empty($password))){
    $sql = "UPDATE driver SET password = sha1($password) WHERE email = '$email'";
}

if (isset($phoneNum) && (!empty($phoneNum))){
    $sql = "UPDATE driver SET phoneNum = '$phoneNum' WHERE email = '$email'";
}

if (isset($residentialHall) && (!empty($residentialHall))){
    $sql = "UPDATE driver SET residentialHall = '$residentialHall' WHERE email = '$email'";
}

if (isset($carBrand) && (!empty($carBrand))){
    $sql = "UPDATE driver SET carBrand = '$carBrand' WHERE email = '$email'";
}

if (isset($carModel) && (!empty($carModel))){
    $sql = "UPDATE driver SET carModel = '$carModel' WHERE email = '$email'";
}

if (isset($carPlate) && (!empty($carPlate))){
    $sql = "UPDATE driver SET carPlate = '$carPlate' WHERE email = '$email'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
    if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["email"].",".$row["fName"].",".$row["lName"].",".$row["matric"].",".$row["phoneNum"].",".$row["residentialHall"].",".$row["carBrand"].",".$row["carModel"].",".$row["carPlate"];
        }
    }else{
        echo "failed,null,null,null,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>