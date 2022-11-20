//const String serverUrlCorta = '10.0.2.2:3000';
//const String serverUrlCorta = '192.168.1.13:3000';
const String serverUrlCorta = '40.88.149.7/node/node';
//const String serverUrlCorta = '00d0-190-236-246-82.ngrok.io';
const String serverUrl = 'http://$serverUrlCorta';
const String rImages = 'assets/images/';
const bool mostrarLog = false;
const String TABLE_NAME_PRE_TAREA_ESPARRAGO = 'pre_tarea_esparrago';
const String TABLE_NAME_PERSONAL_PRE_TAREA_ESPARRAGO =
    'personal_pre_tarea_esparrago';

const String TABLE_PRETAREAESPARRAGO = "CREATE TABLE pre_tarea_esparrago(" +
    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
    "itempretareaesparragosvarios INTEGER," +
    "fecha DATETIME," +
    "fechamod DATETIME," +
    "horainicio DATETIME," +
    "horafin DATETIME," +
    "pausainicio DATETIME," +
    "pausafin DATETIME," +
    "linea INTEGER," +
    "idcentrocosto INTEGER," +
    "codigosupervisor STRING," +
    "codigodigitador STRING," +
    "idusuario STRING," +
    "idestado INTEGER," +
    "turnotareo STRING," +
    "imei STRING," +
    "diasiguiente BOOLEAN," +
    "key INTEGER," +
    "idtipotarea INTEGER" +
    ")";

const String TABLE_PERSONALPRETAREAESPARRAGO =
    "CREATE TABLE personal_pre_tarea_esparrago(" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "id_pre_tarea_esparrago INTEGER REFERENCES pre_tarea_esparrago(id) ON DELETE CASCADE," +
        "itempersonalpretareaesparrago INTEGER," +
        "fecha DATETIME," +
        "hora DATETIME," +
        "idestado INTEGER," +
        "itempretareaesparragovarios INTEGER," +
        "codigotkcaja STRING," +
        "idlabor INTEGER," +
        "idcliente INTEGER," +
        "idvia INTEGER," +
        "correlativocaja INTEGER," +
        "codigotkmesa STRING," +
        "mesa STRING," +
        "linea STRING," +
        "correlativomesa INTEGER," +
        "idusuario INTEGER," +
        "fechamod DATETIME," +
        "key DATETIME," +
        "esperandocierre BOOLEAN," +
        "idcalibre INTEGER" +
        ")";
