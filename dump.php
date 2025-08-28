<?php 

require 'vendor/autoload.php';

use Spatie\DbDumper\Databases\MySql;

try {
    MySQL:: create()
        ->setDumpBinaryPath('C:\wamp64\bin\mysql\mysql8.0.31\bin')
        ->setHost('localhost')
        ->setDbName('marketplace')
        ->setUserName('root')
        ->setPassword('')
        ->dumpToFile('\\backups\backup' . date('YmdsHis') . '.sql');
    echo 'Dump gerado com sucesso!';
}
catch(exception $e) {
    echo 'Erro ao gerar dump: ' . $e->getMessage();
}