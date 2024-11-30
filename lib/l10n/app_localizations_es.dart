// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get journal => 'Diario';

  @override
  String get partners => 'Parejas';

  @override
  String get learn => 'Aprende';

  @override
  String get allEntries => 'Todas las entradas';

  @override
  String get onlySex => 'Filtrar sexo';

  @override
  String get onlySolo => 'Filtrar solo';

  @override
  String get logActivity => 'Registrar actividad';

  @override
  String get safety => 'Seguridad';

  @override
  String get safe => 'Protegido';

  @override
  String get safeSex => 'Sexo protegido';

  @override
  String get safeMsg => 'Aunque el uso del condón está asociado a un riesgo muy bajo de ITS, no existe el sexo 100% libre de riesgo';

  @override
  String get unsafe => 'Muy inseguro';

  @override
  String get unsafeSex => 'Sexo muy inseguro';

  @override
  String get unsafeMsg => 'Alto nivel de riesgo ya que no se ha usado anticonceptivo';

  @override
  String get partiallyUnsafe => 'Parcialmente inseguro';

  @override
  String get partiallyUnsafeSex => 'Sexo parcialmente inseguro';

  @override
  String get partiallyUnsafeMsg => 'Parcialmente inseguro debido a que aunque se prevenga potencialmente contra el embarazo puedes seguir contrayendo Infecciones de Transmisión Sexual (ITS)';

  @override
  String get birthControl => 'Método anticonceptivo';

  @override
  String get min => 'min.';

  @override
  String get byMe => 'por mi';

  @override
  String get byPartner => 'por pareja';

  @override
  String get byBoth => 'por ambos';

  @override
  String get performance => 'Rendimiento';

  @override
  String get highlights => 'Destacado';

  @override
  String orgasmsByMe(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orgasmos mios',
      one: 'orgasmo mio',
    );
    return '$_temp0';
  }

  @override
  String orgasmsByPartner(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orgasmos de pareja',
      one: 'orgasmo de pareja',
    );
    return '$_temp0';
  }

  @override
  String get practices => 'Practicas';

  @override
  String get sexualActivity => 'Actividad sexual';

  @override
  String initiatedIt(String initiator) {
    String _temp0 = intl.Intl.selectLogic(
      initiator,
      {
        'me': 'lo he iniciado',
        'both': 'lo hemos iniciado',
        'other': 'lo ha iniciado',
      },
    );
    return '$_temp0';
  }

  @override
  String get editActivity => 'Editar actividad';

  @override
  String get addPartner => 'Añadir pareja';

  @override
  String get createPartner => 'Crear pareja';

  @override
  String get editPartner => 'Editar pareja';

  @override
  String get man => 'Hombre';

  @override
  String get transMan => 'Hombre trans';

  @override
  String get woman => 'Mujer';

  @override
  String get transWoman => 'Mujer trans';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Femenino';

  @override
  String get nonBinary => 'No binario';

  @override
  String get name => 'Nombre';

  @override
  String get nameHint => 'Escriba nombre...';

  @override
  String get notes => 'Notas';

  @override
  String get notesHint => 'Escriba notas...';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String get moreFields => 'Más campos';

  @override
  String get lessFields => 'Menos campos';

  @override
  String get rating => 'Valoración';

  @override
  String get duration => 'Duración (en min.)';

  @override
  String get orgasms => 'Orgasmos';

  @override
  String get partnerOrgasms => 'Orgasmos de pareja';

  @override
  String get meetingDate => 'Fecha de encuentro';

  @override
  String get gender => 'Género';

  @override
  String get sex => 'Sexo';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownPartner => 'Desconocido';

  @override
  String get unknownPlace => 'Lugar desconocido';

  @override
  String get solo => 'Solo';

  @override
  String get sexualIntercourse => 'Relación sexual';

  @override
  String get masturbation => 'Masturbación';

  @override
  String get activityType => 'Tipo de actividad';

  @override
  String get partner => 'Pareja';

  @override
  String get me => 'Yo';

  @override
  String get both => 'Ambos';

  @override
  String get partnerBirthControl => 'Método anticonceptivo de pareja';

  @override
  String get noBirthControl => 'Sin método anticonceptivo';

  @override
  String get noInitiator => 'Sin iniciador';

  @override
  String get place => 'Lugar';

  @override
  String get location => 'Dirección';

  @override
  String get initiator => 'Iniciador';

  @override
  String get mood => 'Estado de ánimo';

  @override
  String get noSexualActivity => 'Sin actividad sexual...';

  @override
  String get noContent => 'No hay contenido que mostrar';

  @override
  String get noStatistics => 'No hay estadísticas aún';

  @override
  String get noSummary => 'No hay resumen aún';

  @override
  String get noActivity => 'Tu diario esta vacío';

  @override
  String get noPartners => 'No hay parejas aún';

  @override
  String get settings => 'Ajustes';

  @override
  String get colorScheme => 'Color';

  @override
  String get defaultColorScheme => 'Predeterminado';

  @override
  String get dynamicColorScheme => 'Dinámico';

  @override
  String get love => 'Rosa Amor';

  @override
  String get lust => 'Morado Lujuria';

  @override
  String get lovelust => 'Rosa LoveLust';

  @override
  String get lustfullove => 'Rosa y Morado';

  @override
  String get lovefullust => 'Morado y Rosa';

  @override
  String get lipstick => 'Rojo Carmín';

  @override
  String get shimapan => 'Turquesa Shimapan';

  @override
  String get blue => 'Blue Movie';

  @override
  String get monochrome => 'Monocromático';

  @override
  String get experimental => 'Experimental';

  @override
  String get trueBlack => 'Negro puro';

  @override
  String get trueBlackDescription => 'Usa negro puro para pantallas OLED';

  @override
  String get material => 'Material';

  @override
  String get materialDescription => 'Usa la interfaz de Material UI';

  @override
  String get modernUI => 'Interfaz moderna';

  @override
  String get modernUIDescription => 'Prueba la nueva interfaz experimental';

  @override
  String get appearance => 'Aspecto';

  @override
  String get theme => 'Tema';

  @override
  String get chooseTheme => 'Elegir tema';

  @override
  String get system => 'Predeterminado del sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get defaultAppIcon => 'Predeterminado';

  @override
  String get beta => 'Beta';

  @override
  String get white => 'Blanco';

  @override
  String get black => 'Negro';

  @override
  String get monoWhite => 'Blanco Beso';

  @override
  String get monoBlack => 'Negro Cuero';

  @override
  String get filled => 'Relleno';

  @override
  String get filledWhite => 'Relleno Blanco';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Morado';

  @override
  String get deepPurple => 'Morado Profundo';

  @override
  String get neon => 'Neón';

  @override
  String get glow => 'Brillo';

  @override
  String get pride => 'Orgullo';

  @override
  String get prideRainbow => 'Orgullo: Arcoíris';

  @override
  String get prideRainbowLine => 'Orgullo: Línea Arcoíris';

  @override
  String get prideBi => 'Orgullo: Bi';

  @override
  String get prideTrans => 'Orgullo: Trans';

  @override
  String get prideAce => 'Orgullo: Ace';

  @override
  String get prideRomania => 'Orgullo: Rumania';

  @override
  String get sexapill => 'Sexapill';

  @override
  String get sexapillWhite => 'Sexapill Blanco';

  @override
  String get health => 'Salud';

  @override
  String get health2 => 'Salud 2';

  @override
  String get health3 => 'Salud 3';

  @override
  String get requireFingerprint => 'Requerir huella';

  @override
  String get requireFingerprintDescription => 'Requerir huella para acceder a la app';

  @override
  String get requireFace => 'Requerir reconocimiento facial';

  @override
  String get requireFaceDescription => 'Requerir reconocimiento facial para acceder a la app';

  @override
  String get requireFaceID => 'Requerir FaceID';

  @override
  String get requireFaceIDDescription => 'Requerir FaceID para acceder a la app';

  @override
  String get requireTouchID => 'Requerir TouchID';

  @override
  String get requireTouchIDDescription => 'Requerir TouchID para acceder a la app';

  @override
  String get requirePasscode => 'Requerir contraseña';

  @override
  String get requirePasscodeDescription => 'Requerir contraseña para acceder a la app';

  @override
  String get requireAuth => 'Requerir autenticación';

  @override
  String get requireAuthDescription => 'Requerir autenticación para acceder a la app';

  @override
  String get requireAuthToAccess => 'Autenticación requerida para acceder';

  @override
  String get requireAuthToConfirm => 'Autenticación requerida para confirmar';

  @override
  String get authFailed => 'Autenticación ha fallado';

  @override
  String get authRetry => 'Reintentar autenticación';

  @override
  String get contentHidden => 'Contenido oculto';

  @override
  String get sensitiveContent => 'Contenido sensible';

  @override
  String get privacyMode => 'Modo privacidad';

  @override
  String get privacyModeDescription => 'Oculta información sensible como nombres de parejas';

  @override
  String get sensitiveMode => 'Filtro de lenguaje';

  @override
  String get sensitiveModeDescription => 'Oculta etiquetas y textos sugerentes';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get signIn => 'Acceder';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get clearData => 'Borrar todos los datos';

  @override
  String get clearDataDescription => 'Elimina el almacenamiento local de la app';

  @override
  String get clearPersonalData => 'Borrar datos personales';

  @override
  String get clearPersonalDataDescription => 'Elimina el diario y parejas';

  @override
  String get initialFetch => 'Descargar datos';

  @override
  String get initialFetchDescription => 'Recibe los datos guardados desde el servidor';

  @override
  String get fetchStaticData => 'Cargar datos estáticos';

  @override
  String get loggedIn => 'Sesión iniciada';

  @override
  String get fetch => 'Cargar';

  @override
  String get version => 'Versión de app';

  @override
  String get buildNumber => 'Número de compilación';

  @override
  String get installerStore => 'Tienda de instalación';

  @override
  String get confirmClearDataTitle => 'Borrar datos';

  @override
  String get confirmClearDataDescription => '¿Estas seguro de que quieres borrar los datos?';

  @override
  String get appIcon => 'Icono de app';

  @override
  String get condom => 'Condón';

  @override
  String get cervicalCap => 'Capuchón cervical';

  @override
  String get contraceptiveImplant => 'Implante anticonceptivo';

  @override
  String get contraceptivePatch => 'Parche anticonceptivo';

  @override
  String get contraceptiveShot => 'Inyección anticonceptivo';

  @override
  String get diaphragm => 'Diafragma';

  @override
  String get infertility => 'Infertilidad';

  @override
  String get internalCondom => 'Condón interno';

  @override
  String get intrauterineDevice => 'Dispositivo Intrauterino (DIU)';

  @override
  String get outercourse => 'Sin penetración';

  @override
  String get pill => 'Pildora';

  @override
  String get pullOut => 'Marcha atrás';

  @override
  String get sponge => 'Esponja';

  @override
  String get vaginalRing => 'Anillo vaginal';

  @override
  String get tubalLigation => 'Ligadura de trompas';

  @override
  String get vasectomy => 'Vasectomía';

  @override
  String get unsafeContraceptive => 'Anticonceptivo no seguro';

  @override
  String get backyard => 'Patio interior';

  @override
  String get bar => 'Bar';

  @override
  String get bathroom => 'Baño';

  @override
  String get beach => 'Playa';

  @override
  String get bedroom => 'Cama';

  @override
  String get car => 'Coche';

  @override
  String get chair => 'Silla';

  @override
  String get cinema => 'Cine';

  @override
  String get elevator => 'Ascensor';

  @override
  String get forest => 'Bosque';

  @override
  String get garage => 'Garaje';

  @override
  String get hotel => 'Hotel';

  @override
  String get jacuzzi => 'Jacuzzi';

  @override
  String get kitchen => 'Cocina';

  @override
  String get livingRoom => 'Salón';

  @override
  String get museum => 'Museo';

  @override
  String get other => 'Otro';

  @override
  String get party => 'Fiesta';

  @override
  String get plane => 'Avión';

  @override
  String get pool => 'Piscina';

  @override
  String get public => 'Público';

  @override
  String get restroom => 'Lavabo';

  @override
  String get roof => 'Tejado';

  @override
  String get school => 'Instituto';

  @override
  String get ship => 'Barco';

  @override
  String get shower => 'Ducha';

  @override
  String get sofa => 'Sofá';

  @override
  String get table => 'Mesa';

  @override
  String get theatre => 'Teatro';

  @override
  String get train => 'Tren';

  @override
  String get work => 'Trabajo';

  @override
  String get anal => 'Anal';

  @override
  String get bdsm => 'BDSM';

  @override
  String get bondage => 'Bondage';

  @override
  String get choking => 'Asfixia';

  @override
  String get cuddling => 'Caricias';

  @override
  String get domination => 'Dominación';

  @override
  String get fingering => 'Dedos';

  @override
  String get handjob => 'Paja';

  @override
  String get oral => 'Oral';

  @override
  String get toy => 'Juguete';

  @override
  String get vaginal => 'Vaginal';

  @override
  String get anilingus => 'Anilingus';

  @override
  String get blowjob => 'Mamada';

  @override
  String get cunnilingus => 'Cunnilingus';

  @override
  String get titjob => 'Cubana';

  @override
  String get whiteKiss => 'Beso blanco';

  @override
  String get creampie => 'Creampie';

  @override
  String get adventurous => 'Aventurero';

  @override
  String get comfortable => 'Cómodo';

  @override
  String get crazy => 'Loco';

  @override
  String get horny => 'Cachondo';

  @override
  String get lazy => 'Perezoso';

  @override
  String get playful => 'Juguetón';

  @override
  String get relaxed => 'Relajado';

  @override
  String get safeMood => 'Seguro';

  @override
  String get scared => 'Asustado';

  @override
  String get surprised => 'Sorprendido';

  @override
  String get angry => 'Enfadado';

  @override
  String get unsafeMood => 'Inseguro';

  @override
  String get noMood => 'Sin ánimo';

  @override
  String get unsupportedStatistic => 'Estadística no soportada';

  @override
  String get unsupportedStatisticDescription => 'No hay widget para este tipo de estadística';

  @override
  String get daysWithoutSex => 'Días sin sexo';

  @override
  String get daysWithoutMasturbation => 'Días sin masturbación';

  @override
  String get lastRelationship => 'Última relacion sexual';

  @override
  String get lastMasturbation => 'Última masturbación';

  @override
  String get weeklyReport => 'Informe semanal';

  @override
  String get days => 'Días';

  @override
  String get withoutSex => 'sin sexo';

  @override
  String get withoutMasturbation => 'sin masturbación';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get help => 'Ayuda';
}
