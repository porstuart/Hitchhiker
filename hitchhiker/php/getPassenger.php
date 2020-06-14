<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM passenger WHERE EMAIL = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["email"].",".$row["fName"].",".$row["lName"].",".$row["phoneNum"].",".$row["matric"];
    }
}else{
    echo "failed,null,null,null,null,null,null,null";
}