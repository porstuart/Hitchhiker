<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM trip, driver WHERE passenger_email IS NULL ORDER BY tripID DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["trips"] = array();
    while ($row = $result ->fetch_assoc()){
        $triplist = array();
        $triplist[tripID] = $row["tripID"];
        $triplist[origin] = $row["origin"];
        $triplist[destination] = $row["destination"];
        $triplist[pickupPoint] = $row["pickupPoint"];
        $triplist[depatureDate] = $row["depatureDate"];
        $triplist[depatureTime] = $row["depatureTime"];
        $triplist[arrivalTime] = $row["arrivalTime"];
        $triplist[travellingPreferences] = $row["travellingPreferences"];
        $triplist[rewards] = $row["rewards"];
        $triplist[driverEmail] = $row["driverEmail"];
        array_push($response["trips"], $triplist);    
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>