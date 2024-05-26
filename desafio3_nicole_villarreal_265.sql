-- Active: 1716753528910@@127.0.0.1@5432
CREATE DATABASE -- Active: 1716753528910@@127.0.0.1@5432
CREATE DATABASE desafio3_nicole_villarreal_265

CREATE TABLE usuarios (
    id SERIAL,
    email TEXT,
    nombre TEXT,
    apellido TEXT,
    rol VARCHAR
);

select * from usuarios;

INSERT INTO
    usuarios (email, nombre, apellido, rol)
VALUES (
        'nicole@ncvc.com',
        'Nicole',
        'Villarreal',
        'administrador'
    ),
    (
        'belen@ncvc.com',
        'Belen',
        'Maza',
        'usuario'
    ),
    (
        'oscar@ncvc.com',
        'Oscar',
        'Ugarte',
        'usuario'
    ),
    (
        'laura@ncvc.com',
        'Laura',
        'Cerda',
        'usuario'
    ),
    (
        'robinson@ncvc.com',
        'Robinson',
        'Osorio',
        'usuario'
    );

select * from usuarios;

CREATE TABLE posts (
    id SERIAL,
    titulo VARCHAR(50),
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

INSERT INTO
    posts (
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
VALUES (
        'ingeniera en redes',
        'Help Desk',
        '06-01-2021 09:00:00'::timestamp,
        '06-01-2024 09:00:00'::timestamp,
        true,
        5
    ),
    (
        'Contadora',
        'Contadora tributaria',
        '01-03-2014 08:00:00'::timestamp,
        '01-03-2024 15:10:00'::timestamp,
        false,
        4
    ),
    (
        'Finanzas',
        'Controling',
        '01-09-2019 08:30:00'::timestamp,
        '01-09-2024 08:30:00'::timestamp,
        true,
        3
    ),
    (
        'Ingeniero Industrial',
        'Gerente Logisitca',
        '01-09-2022 09:00:00'::timestamp,
        '01-09-2024 09:00:00'::timestamp,
        true,
        2
    ),
    (
        'Administracion en rrhh',
        'Asistente de rrhh',
        '01-07-2013 09:00:00'::timestamp,
        '01-07-2024 09:00:00'::timestamp,
        true,
        1
    );

select * from posts;

CREATE TABLE comentarios (
    id SERIAL,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

INSERT INTO
    comentarios (
        contenido,
        fecha_creacion,
        usuario_id,
        post_id
    )
VALUES (
        'servicial',
        '03-04-2023 09:00:00'::timestamp,
        1,
        1
    ),
    (
        'honesta',
        '01-08-2023 08:00:00'::timestamp,
        2,
        1
    ),
    (
        'virtuos',
        '01-06-2023 08:00:00'::timestamp,
        2,
        1
    ),
    (
        'chistoso',
        '01-03-2023 08:00:00'::timestamp,
        2,
        1
    ),
    (
        'humano',
        '01-02-2023 08:00:00'::timestamp,
        2,
        1
    );

select * from comentarios;

--1-
select * from usuarios;

select * from posts;

select * from comentarios;

--2-
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
    INNER JOIN posts p ON u.id = p.usuario_id;

--3-
SELECT p.id, p.titulo, p.contenido
FROM posts p
    INNER JOIN usuarios usuario ON p.usuario_id = usuario.id
WHERE
    usuario.rol = 'administrador';

--4-
SELECT
    u.id as usuario_id,
    u.email,
    COUNT(*) as cantidad_posts
FROM posts p
    LEFT JOIN usuarios u ON p.usuario_id = u.id
WHERE
    u.email <> ''
GROUP BY
    u.id,
    u.email
ORDER BY cantidad_posts DESC;

--5-
SELECT a.email
FROM usuarios a
    INNER JOIN (
        SELECT usuario_id, COUNT(*) as num_posts
        FROM posts
        GROUP BY
            usuario_id
        ORDER BY num_posts DESC
        LIMIT 1
    ) as b ON a.id = b.usuario_id;

--6-
SELECT u.nombre, MAX(p.fecha_creacion) ultimo_post
FROM usuarios u
    INNER JOIN posts p ON u.id = p.usuario_id
GROUP BY
    u.nombre
ORDER BY ultimo_post DESC;

--7-
SELECT p.titulo, p.contenido
FROM posts p
    JOIN (
        SELECT post_id, COUNT(*) AS num_comment
        FROM comentarios
        GROUP BY
            post_id
    ) c ON p.id = c.post_id
WHERE
    c.num_comment = (
        SELECT MAX(num_comment)
        FROM (
                SELECT post_id, COUNT(*) as num_comment
                FROM comentarios
                GROUP BY
                    post_id
            ) as subquery
    );

--8-
SELECT
    u1.email as autor_post,
    p.titulo as titulo_post,
    p.contenido as contenido_post,
    u2.email as autor_cometario,
    c.contenido as comentario
FROM
    posts p
    LEFT JOIN comentarios c ON p.id = c.post_id
    LEFT JOIN usuarios u1 ON p.usuario_id = u1.id
    INNER JOIN usuarios u2 ON u2.id = c.usuario_id;

--9-
SELECT u.nombre, c.contenido contenido_ultimo_comentario
FROM (
        SELECT
            usuario_id,
            MAX(fecha_creacion) AS fecha_ult_comentario
        FROM comentarios
        GROUP BY
            usuario_id
    ) AS ult_comentario
    INNER JOIN comentarios c ON c.usuario_id = ult_comentario.usuario_id
    AND c.fecha_creacion = ult_comentario.fecha_ult_comentario
    INNER JOIN usuarios u ON u.id = c.usuario_id;

--10-
SELECT
    u.email as mail_usuarios_sin_comentarios
FROM usuarios u
    LEFT JOIN comentarios c on u.id = c.usuario_id
GROUP BY
    u.email
HAVING
    COUNT(c.id) = 0;