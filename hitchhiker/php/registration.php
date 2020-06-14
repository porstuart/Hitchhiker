<?php
error_reporting(0);
include_once ("dbconnect.php");

$encoded_string = $_POST["encoded_string"];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$confPassword = sha1($_POST['confPassword']);
$fName = $_POST['fName'];
$lName = $_POST['lName'];
$gender = $_POST['gender'];
$matric = $_POST['matric'];
$phoneNum = $_POST['phoneNum'];
$emergeNum = $_POST['emergeNum'];
$residentialHall = $_POST['residentialHall'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO passenger(email, password, fName, lName, gender, matric, phoneNum, emergeNum, residentialHall, verify, status, blacklist, passengerImage) VALUES ('$email','$password','$fName','$lName','$gender', '$matric', '$phoneNum', '$emergeNum', '$residentialHall', '1', 'Not-Approved', 'whitelisted', '$imagename')";

//empty string value in sha1 encryption
$empty_string = "da39a3ee5e6b4b0d3255bfef95601890afd80709";
if($empty_string == $password){
    echo "password empty error";
    exit();
}

if($password != $confPassword){
    echo "Password not matched, please re-enter password";
    exit();
}

$checkEmail = "SELECT email FROM passenger WHERE email = '$email'";
$result = $conn->query($checkEmail);


if($result->num_rows == 0){
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../matric/'.$imagename.'.jpg';
        file_put_contents($path, $decoded_string);
        echo "success";
    } else {
        echo "failed";
    }
} else {
    echo "use another email";
}

?>