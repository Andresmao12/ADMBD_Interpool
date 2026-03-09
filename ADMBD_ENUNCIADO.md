# CASO DE ESTUDIO

La Interpol (mayor organización de policía a nivel mundial) está muy preocupada por la suerte que pudo haber corrido el avión de Malasyan Airlines, el cual se encuentra desaparecido hace 13 días y del cual aún no hay pistas de lo sucedido.

Una de las hipótesis que se manejan es que pudo haber sido un atentado terrorista o un secuestro.

Por eso, está muy interesada en crear una base de datos que le ayude a llevar la información de los grupos terroristas del mundo y lo ha contratado a usted para que le haga el modelo entidad relación correspondiente.

---

## Información sobre grupos terroristas

En el mundo existen varios grupos terroristas de los cuales se necesita saber datos como:

- fecha de origen
- nombre
- tiempo de funcionamiento
- entre otras cosas

Cada grupo terrorista proviene de un **país específico**.

---

## Información sobre países

De los diferentes países donde hay grupos terroristas se desea conocer:

- nombre
- número de habitantes
- área de extensión territorial

---

## Información sobre líderes

Aunque cada grupo terrorista puede tener **varios líderes**, se desea modelar la información básica del **líder principal**.

---

## Información sobre integrantes

Además es necesario contar con los **datos básicos de los integrantes** de cada uno de los grupos terroristas.

Es de aclarar que:

- una persona puede ser (o pudo haber sido) integrante de **varios grupos terroristas**.

Es importante para la Interpol conocer:

- la **fecha en que se incorporó** un integrante a un grupo terrorista.

---

## Información sobre atentados

Cada grupo terrorista ha cometido **atentados** de los cuales se desea llevar el registro.

Para identificar cada atentado cometido por un grupo terrorista:

- la Interpol codifica sus atentados **del 1 en adelante para cada grupo terrorista**.

También es importante saber:

- la fecha del atentado
- otros datos del mismo

---

## Tipos de atentados

Para la Interpol es importante manejar **dos tipos de atentados**:

- Atentados **aéreos**
- Atentados **marítimos**

Ambas hipótesis se manejan en el caso de Malasyan Airlines.

### Atentados aéreos

Se debe conocer:

- a cuantos **pies de altura** se cometió el atentado

### Atentados marítimos

Se debe conocer:

- el **tipo de navío (o barco)** al cual se le hizo el atentado

---

## Registro de aviones

Para la Interpol es importante llevar un registro de los **aviones que han sido víctimas de atentados aéreos**.

De dichos aviones es importante llevar:

- datos técnicos básicos
  - marca
  - modelo
  - etc.

---

## Registro de océanos

De los atentados marítimos se desea llevar registro de los **océanos donde se han cometido**.

Para efectos estadísticos es importante registrar:

- nombre
- extensión marítima
- entre otras cosas

---

## Personas fallecidas

La Interpol ha llevado durante años el registro de:

- las **personas fallecidas en los diferentes atentados**

---

## Información importante para la Interpol

La Interpol necesita conocer:

- qué **personas fallecieron en un atentado dado**
- en **cuántos atentados ha participado un integrante**
- de **qué país es el grupo terrorista que cometió un atentado**
- cuál es el **océano con mayor número de atentados marítimos**
- cuál es el **tipo de avión con mayor cantidad de atentados en la historia**

Todo esto con el fin de tener pistas del **avión desaparecido**.

 

---

# Análisis del caso de estudio para Base de Datos

## Entidades principales

### País
Representa los países donde existen grupos terroristas.

Atributos:
- id_pais (PK)
- nombre
- numero_habitantes
- area_territorial

Relaciones:
- Un país puede tener varios grupos terroristas

---

### Grupo_Terrorista

Atributos:
- id_grupo (PK)
- nombre
- fecha_origen
- tiempo_funcionamiento
- id_pais (FK)

Relaciones:
- Pertenece a un país
- Tiene integrantes
- Tiene líderes
- Comete atentados

---

### Persona

Representa tanto integrantes como fallecidos.

Atributos:
- id_persona (PK)
- nombre
- nacionalidad
- fecha_nacimiento
- otros_datos

Relaciones:
- Puede pertenecer a varios grupos terroristas
- Puede fallecer en un atentado

---

### Integrante_Grupo

Tabla intermedia para la relación muchos a muchos.

Atributos:
- id_persona (FK)
- id_grupo (FK)
- fecha_ingreso

Clave primaria compuesta:
- (id_persona, id_grupo)

---

### Lider

Representa al líder principal del grupo.

Atributos:
- id_lider (PK)
- id_persona (FK)
- id_grupo (FK)

Relaciones:
- Un grupo tiene un líder principal

---

### Atentado

Atributos:
- id_grupo (FK)
- codigo_atentado
- fecha_atentado
- descripcion

Clave primaria compuesta:
- (id_grupo, codigo_atentado)

Relaciones:
- Un grupo puede cometer varios atentados

---

### Atentado_Aereo

Subtipo de atentado.

Atributos:
- id_grupo (FK)
- codigo_atentado (FK)
- altura_pies
- id_avion (FK)

---

### Atentado_Maritimo

Subtipo de atentado.

Atributos:
- id_grupo (FK)
- codigo_atentado (FK)
- tipo_navio
- id_oceano (FK)

---

### Avion

Atributos:
- id_avion (PK)
- marca
- modelo
- otros_datos_tecnicos

Relaciones:
- Puede estar asociado a atentados aéreos

---

### Oceano

Atributos:
- id_oceano (PK)
- nombre
- extension_maritima

Relaciones:
- Puede tener varios atentados marítimos

---

### Fallecido

Relación entre persona y atentado.

Atributos:
- id_persona (FK)
- id_grupo (FK)
- codigo_atentado (FK)

Clave primaria compuesta:
- (id_persona, id_grupo, codigo_atentado)

Relaciones:
- Permite saber qué persona murió en qué atentado