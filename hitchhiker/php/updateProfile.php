<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];
$phoneNum = $_POST['phoneNum'];
$emergeNum = $_POST['emergeNum'];
$residentialHall = $_POST['$residentialHall'];

$usersql = "SELECT * FROM passenger WHERE email = '$email'";

if (isset($password) && (!empty($password))){
    $sql = "UPDATE passenger SET password = sha1($password) WHERE email = '$email'";
}

if (isset($phoneNum) && (!empty($phoneNum))){
    $sql = "UPDATE passenger SET phoneNum = '$phoneNum' WHERE email = '$email'";
}

if (isset($emergeNum) && (!empty($emergeNum))){
    $sql = "UPDATE passenger SET emergeNum = '$emergeNum' WHERE email = '$email'";
}

if (isset($reisdentialHall) && (!empty($residentialHall))){
    $sql = "UPDATE passenger SET residentialHall = '$residentialHall' WHERE email = '$email'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
    if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["email"].",".$row["fName"].",".$row["lName"].",".$row["matric"].",".$row["phoneNum"].",".$row["emergeNum"].",".$row["residentialHall"];
        }
    }else{
        echo "failed,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
