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
