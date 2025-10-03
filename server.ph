<?php
// server.php

// Imposta l'header per JSON
header('Content-Type: application/json');

// Abilita CORS per test locali
header('Access-Control-Allow-Origin: *');

// Definizione velocità medie per ogni mezzo (km/h)
$velocita = array(
    'auto' => 80,
    'treno' => 120,
    'aereo' => 800,
    'bici' => 20
);

// Nomi descrittivi dei mezzi
$nomiMezzi = array(
    'auto' => 'Automobile',
    'treno' => 'Treno',
    'aereo' => 'Aereo',
    'bici' => 'Bicicletta'
);

// Recupera i parametri usando $_REQUEST
$distanza = isset($_REQUEST['distanza']) ? floatval($_REQUEST['distanza']) : 0;
$mezzo = isset($_REQUEST['mezzo']) ? $_REQUEST['mezzo'] : '';

// Validazione input
if ($distanza <= 0) {
    echo json_encode(array(
        'success' => false,
        'message' => 'La distanza deve essere maggiore di zero'
    ));
    exit;
}

if (empty($mezzo) || !array_key_exists($mezzo, $velocita)) {
    echo json_encode(array(
        'success' => false,
        'message' => 'Mezzo di trasporto non valido'
    ));
    exit;
}

// Calcolo della durata
$velocitaMezzo = $velocita[$mezzo];
$durataOre = $distanza / $velocitaMezzo;

// Formattazione della durata
function formattaDurata($ore) {
    $oreIntere = floor($ore);
    $minutiDecimali = ($ore - $oreIntere) * 60;
    $minutiInteri = round($minutiDecimali);
    
    if ($oreIntere > 0 && $minutiInteri > 0) {
        return $oreIntere . ' ore e ' . $minutiInteri . ' minuti';
    } elseif ($oreIntere > 0) {
        return $oreIntere . ' ore';
    } else {
        return $minutiInteri . ' minuti';
    }
}

// Prepara la risposta
$risposta = array(
    'success' => true,
    'distanza' => $distanza,
    'mezzo' => $nomiMezzi[$mezzo],
    'velocita' => $velocitaMezzo,
    'durataOre' => round($durataOre, 2),
    'durata' => formattaDurata($durataOre)
);

// Invia la risposta JSON
echo json_encode($risposta);
?>
