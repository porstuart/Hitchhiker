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
$residentialHall = $_POST['residentialHall'];
$carBrand = $_POST['carBrand'];
$carModel = $_POST['carModel'];
$carPlate = $_POST['carPlate'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;

$sqlinsert = "INSERT INTO driver(email, password, fName, lName, gender, matric, phoneNum, residentialHall, carBrand, carModel, carPlate, verify, status, blacklist,driverImage, tripCount) VALUES ('$email','$password','$fName','$lName','$gender','$matric', '$phoneNum', '$residentialHall', '$carBrand', '$carModel', '$carPlate', '1', 'Not-Approved', 'whitelisted', '$imagename', '0')";

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

$checkEmail = "SELECT email FROM driver WHERE email = '$email'";
$result = $conn->query($checkEmail);


if($result->num_rows == 0){
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../license/'.$imagename.'.jpg';
        file_put_contents($path, $decoded_string);
        echo "success";
    } else {
        echo "failed";
    }
} else {
    echo "use another email";
}



function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Hitchhiker'; 
    $message = 'Please confirm your email using link bellow' . "\r\n \r\n" . 'http://pickupandlaundry.com/hitchhiker/php/verify.php?email='.$email;

    $headers = 'From: noreply_hitchhiker@hitchhikeradmin.com' . "\r\n" . 
    'Reply-To: '.$email . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers);
}
?>