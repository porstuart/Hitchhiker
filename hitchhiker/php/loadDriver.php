<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM driver WHERE email = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["driver"] = array();
    while ($row = $result ->fetch_assoc()){
        $driverlist = array();
        $driverlist[email] = $row["email"];
        $driverlist[fName] = $row["fName"];
        $driverlist[lName] = $row["lName"];
        $driverlist[gender] = $row["gender"];
        $driverlist[matric] = $row["matric"];
        $driverlist[phoneNum] = $row["phoneNum"];
        $driverlist[residentialHall] = $row["residentialHall"];
        $driverlist[carBrand] = $row["carBrand"];
        $driverlist[carModel] = $row["carModel"];
        $driverlist[carPlate] = $row["carPlate"];
        array_push($response["driver"], $driverlist);    
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>