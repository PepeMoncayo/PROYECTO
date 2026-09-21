-- ============================================================
-- Athletic Club Football Center — esquema para Supabase
-- Proyecto: qzumbtpcvnrdrohcjond
--
-- CÓMO EJECUTARLO:
-- 1. Entra en tu proyecto de Supabase (https://supabase.com/dashboard)
-- 2. Ve a "SQL Editor" (menú izquierdo) → "New query"
-- 3. Pega todo este archivo y pulsa "Run"
-- 4. Recarga la app (proyecto.html): debería conectar sola
-- ============================================================

create table if not exists jugadores (
  id bigint generated always as identity primary key,
  nombre text not null,
  dorsal integer,
  demarcacion text,
  foto text,
  observaciones text,
  created_at timestamptz not null default now()
);

create table if not exists partidos (
  id bigint generated always as identity primary key,
  competicion text,
  local text,
  visitante text,
  resultado text,
  plan text,
  video text,
  created_at timestamptz not null default now()
);

create table if not exists categorias_video (
  id bigint generated always as identity primary key,
  nombre text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists videos (
  id bigint generated always as identity primary key,
  titulo text not null,
  categoria text,
  video text,
  descripcion text,
  tareas text,
  created_at timestamptz not null default now()
);

create table if not exists usuarios (
  id bigint generated always as identity primary key,
  nombre text not null,
  email text,
  rol text,
  telefono text,
  created_at timestamptz not null default now()
);

create table if not exists scouts (
  id bigint generated always as identity primary key,
  nombre text not null,
  posicion text,
  club text,
  edad integer,
  valoracion integer,
  prioridad text,
  notas text,
  created_at timestamptz not null default now()
);

create table if not exists analisis (
  id bigint generated always as identity primary key,
  titulo text not null,
  tipo text,
  fecha date,
  partido_id bigint references partidos(id) on delete set null,
  jugador_id bigint references jugadores(id) on delete set null,
  video text,
  contenido text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- SEGURIDAD (RLS)
--
-- La app no tiene sistema de login propio: se conecta a Supabase
-- directamente desde el navegador con la clave "anon". Por eso hay
-- que permitir a ese rol leer y escribir en estas tablas, si no,
-- la app no podrá guardar ni mostrar nada.
--
-- IMPORTANTE: esto significa que cualquiera que tenga el archivo
-- proyecto.html (y por tanto la clave anon, que va dentro del
-- propio código) podrá leer y modificar estos datos. Es el mismo
-- nivel de protección que tenía la app antes (ninguno: los datos
-- vivían solo en el navegador de cada persona), pero ahora es
-- compartido. Si en el futuro quieres restringir quién puede
-- entrar, lo natural es añadir un login real con Supabase Auth y
-- cambiar estas políticas para exigir un usuario autenticado.
-- ============================================================

alter table jugadores enable row level security;
alter table partidos enable row level security;
alter table categorias_video enable row level security;
alter table videos enable row level security;
alter table usuarios enable row level security;
alter table scouts enable row level security;
alter table analisis enable row level security;

create policy "anon acceso total" on jugadores for all to anon using (true) with check (true);
create policy "anon acceso total" on partidos for all to anon using (true) with check (true);
create policy "anon acceso total" on categorias_video for all to anon using (true) with check (true);
create policy "anon acceso total" on videos for all to anon using (true) with check (true);
create policy "anon acceso total" on usuarios for all to anon using (true) with check (true);
create policy "anon acceso total" on scouts for all to anon using (true) with check (true);
create policy "anon acceso total" on analisis for all to anon using (true) with check (true);

-- ============================================================
-- DATOS DE EJEMPLO
-- Son los mismos que traía la app por defecto. Sirven para no
-- arrancar con las tablas vacías. Puedes borrarlos luego sin
-- problema, o simplemente no ejecutar este bloque si prefieres
-- empezar de cero.
--
-- ¡OJO! Si ejecutas este script dos veces se duplicarán estas
-- filas de ejemplo (no así la estructura de las tablas). Si eso
-- pasa, borra las filas duplicadas desde el "Table editor".
-- ============================================================

insert into jugadores (nombre, dorsal, demarcacion, foto, observaciones) values
('Julen Agirre', 1, 'Portero', null, ''),
('Iker Zubiaurre', 2, 'Lateral derecho', null, ''),
('Aitor Larrañaga', 3, 'Lateral izquierdo', null, ''),
('Mikel Etxeberria', 4, 'Defensa central', null, ''),
('Gorka Intxausti', 5, 'Defensa central', null, ''),
('Asier Goikoetxea', 6, 'Medio centro', null, 'Buen líder en el vestuario, mejorable en el juego aéreo.'),
('Ander Bilbao', 7, 'Extremo derecho', null, ''),
('Jon Urrutia', 8, 'Medio centro', null, ''),
('Markel Etxarri', 9, 'Delantero', null, 'Muy regular de cara a puerta esta temporada.'),
('Unai Gorostiza', 11, 'Extremo izquierdo', null, '');

insert into partidos (competicion, local, visitante, resultado, plan, video) values
('LaLiga', 'CD Ibaiondo', 'UD Zorrotza', '2-1', 'Presión alta desde el inicio y salida rápida por las bandas. Vigilar el mediocentro rival, muy dado a los pases largos.', ''),
('Copa del Rey', 'Gazte FT', 'CD Ibaiondo', '0-0', 'Partido de ida a doble partido. Plantear un bloque medio-bajo y aprovechar transiciones rápidas.', ''),
('Amistoso', 'CD Ibaiondo', 'Deportivo Otxarkoaga', '3-0', 'Probar el 4-3-3 con los juveniles. Rotar a todo el equipo en la segunda parte.', ''),
('LaLiga', 'AD Rekalde', 'CD Ibaiondo', '1-2', 'Cuidado con sus saques de esquina, son su principal arma. Marcaje individual en área propia.', ''),
('LaLiga', 'CD Ibaiondo', 'CF Errekalde', '1-1', 'Explotar el desmarque de nuestro extremo izquierdo, su lateral derecho llega tarde a la cobertura.', ''),
('Copa del Rey', 'CD Ibaiondo', 'Gazte FT', '2-0', 'Vuelta de la eliminatoria. Salir intensos los primeros 15 minutos para sentenciar la eliminatoria.', ''),
('Amistoso', 'Urban SC', 'CD Ibaiondo', '0-2', 'Partido de pretemporada. Minutos para todos y foco en la puesta a punto física.', ''),
('LaLiga', 'CD Ibaiondo', 'SD Basozelai', '4-1', 'Rival con línea defensiva muy adelantada. Buscar el balón al espacio para los delanteros.', '');

insert into categorias_video (nombre) values
('Partido'), ('Entrenamiento'), ('Táctica'), ('Tareas'), ('Otro');

insert into videos (titulo, categoria, video, descripcion, tareas) values
('Resumen jornada 1', 'Tareas', '', 'Mejores jugadas del primer partido de LaLiga.', 'Recortar los goles a clips de menos de 30 segundos
Subirlo al canal del club'),
('Sesión de presión alta', 'Entrenamiento', '', 'Ejercicio de presión tras pérdida trabajado esta semana.', 'Compartir con el cuerpo técnico antes del viernes'),
('Análisis del rival', 'Táctica', '', 'Vídeo de análisis de la próxima jornada frente al AD Rekalde.', 'Añadir anotaciones sobre saques de esquina
Preparar resumen para la charla táctica'),
('Partido completo vs Gazte FT', 'Partido', '', 'Grabación íntegra del partido de Copa del Rey.', '');

insert into usuarios (nombre, email, rol, telefono) values
('Ainhoa Arteaga', 'ainhoa@club.com', 'Entrenador', '600 111 222'),
('Beñat Uriarte', 'benat@club.com', 'Delegado', '600 333 444'),
('Nagore Etxebarria', 'nagore@club.com', 'Analista', ''),
('Iñaki Zubizarreta', 'inaki@club.com', 'Directivo', '600 555 666');

insert into scouts (nombre, posicion, club, edad, valoracion, prioridad, notas) values
('Jon Etxaniz', 'Portero', 'SD Basozelai', 19, 4, 'Media', 'Buen manejo con los pies, mejorable en el juego aéreo.'),
('Ibai Mendizabal', 'Defensa central', 'CD Basconia', 20, 3, 'Baja', 'Fuerte en el uno contra uno, algo lento en la salida de balón.'),
('Aitor Landa', 'Lateral derecho', 'Deportivo Otxarkoaga', 18, 4, 'Media', 'Muy ofensivo, llega bien a línea de fondo.'),
('Peru Santamaría', 'Interior', 'Urban SC', 21, 5, 'Alta', 'Gran visión de juego, candidato claro para el primer equipo.'),
('Xabat Elorriaga', 'Medio centro', 'CF Errekalde', 19, 3, 'Baja', 'Trabajador, necesita mejorar el último pase.'),
('Iker Muxika', 'Extremo izquierdo', 'AD Rekalde', 17, 4, 'Media', 'Rápido y desequilibrante, aún irregular.'),
('Gari Etxeandia', 'Delantero', 'Gazte FT', 20, 5, 'Alta', 'Gran definición, muy seguido por otros clubes.'),
('Oier Larrinaga', 'Delantero', 'UD Zorrotza', 22, 2, 'Baja', 'Buen físico, le falta continuidad de gol.'),
('Unax Barandika', 'Mediapunta', 'Gazte FT', 18, 4, 'Alta', 'Muy buen golpeo de balón y llegada desde segunda línea.');

insert into analisis (titulo, tipo, fecha, partido_id, jugador_id, video, contenido) values
('Análisis del AD Rekalde', 'Rival', '2026-09-10', null, null, '', 'Presionan alto tras pérdida y buscan el saque de esquina como principal recurso ofensivo. Su punto débil es la banda izquierda.'),
('Balance físico primera vuelta', 'Equipo propio', '2026-09-05', null, null, '', 'Buen nivel de intensidad general, pero se detecta fatiga acumulada en los centrocampistas tras la tercera jornada.'),
('Seguimiento de Peru Santamaría', 'Jugador individual', '2026-08-28', null, 1, '', 'Evolución positiva en la toma de decisiones. Buen candidato para subir dinámica al primer equipo.'),
('Salida de balón en presión alta', 'Modelo de juego', '2026-08-20', null, null, '', 'Propuesta de trabajar la salida en rombo para superar la primera línea de presión rival.');
