<?php
error_reporting(0);
include_once ("dbconnect.php");

$origin = $_POST['origin'];
$destination = $_POST['destination'];
$pickupPoint = $_POST['pickupPoint'];
$depatureDate = $_POST['depatureDate'];
$depatureTime = $_POST['depatureTime'];
$arrivalTime = $_POST['arrivalTime'];
$travellingPreferences = $_POST['travellingPreferences'];
$rewards = $_POST['rewards'];
$driverEmail = $_POST['driverEmail'];
$tripCount = $_POST['tripCount'];

$sqlinsert = "INSERT INTO trip(origin, destination, pickupPoint, depatureDate, depatureTime, arrivalTime, travellingPreferences, rewards, driverEmail) VALUES ('$origin','$destination','$pickupPoint','$depatureDate','$depatureTime', '$arrivalTime', '$travellingPreferences', '$rewards', '$driverEmail')";

if ($conn->query($sqlinsert) === TRUE) {
    $newTrip = $tripCount + 1;
    $sqlTrip = "UPDATE driver SET tripCount = '$newTrip' WHERE email = '$driverEmail'";
    $conn->query($sqlTrip);
    echo "success";
} else {
    echo "failed";
}
?>