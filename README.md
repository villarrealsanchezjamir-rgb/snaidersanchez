# Sistema Integral de Gestión de Flota Vehicular

Sistema propuesto para administrar, controlar y analizar la flota vehicular de una empresa minera mediante un modelo orientado a objetos y una base de datos relacional MySQL 8.

## Contenido

- [Problema](#problema)
- [Objetivo](#objetivo)
- [Alcance](#alcance)
- [Modelo del sistema](#modelo-del-sistema)
- [Diagramas UML](#diagramas-uml)
- [Base de datos](#base-de-datos)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Tecnologías](#tecnologías)

## Problema

La información de vehículos, conductores, asignaciones, mantenimientos y documentos puede encontrarse dispersa en formatos físicos, hojas de cálculo y archivos independientes. Esto dificulta conocer la disponibilidad de la flota, controlar vencimientos, realizar mantenimiento oportuno y conservar una trazabilidad confiable.

## Objetivo

Diseñar un sistema que permita administrar la flota, controlar sus operaciones y facilitar la toma de decisiones mediante información centralizada, trazable y organizada.

## Alcance

El modelo contempla organización minera, áreas, vehículos, conductores, asignaciones, alquileres, mantenimiento, documentación, inspecciones, combustible, incidentes, historial, usuarios y roles.

> Los datos de empresas, placas, personas y ejemplos son ficticios. El alquiler se considera un proceso condicional sujeto a validación del negocio.

## Modelo del sistema

El modelo de dominio contiene **19 clases**, una clase abstracta de diseño (`OperacionVehiculo`) y dos interfaces/protocolos (`Auditable` y `Vencible`).

Las relaciones distinguen asociación, agregación y composición. La herencia se utiliza únicamente en `Asignacion` y `Alquiler`, que heredan de `OperacionVehiculo`.

## Diagramas UML

Todos los diagramas están escritos en Mermaid para que GitHub pueda mostrarlos directamente.

| Diagrama | Archivo |
|---|---|
| Casos de uso | [`01-casos-de-uso.md`](docs/diagramas/01-casos-de-uso.md) |
| Actividades | [`02-actividades.md`](docs/diagramas/02-actividades.md) |
| Clases — modelo completo | [`03-clases.md`](docs/diagramas/03-clases.md) |
| Objetos | [`04-objetos.md`](docs/diagramas/04-objetos.md) |
| Estados | [`05-estados.md`](docs/diagramas/05-estados.md) |
| Secuencia — asignación | [`06-secuencia-asignacion.md`](docs/diagramas/06-secuencia-asignacion.md) |
| Secuencia — inspección | [`07-secuencia-inspeccion.md`](docs/diagramas/07-secuencia-inspeccion.md) |
| Paquetes | [`08-paquetes.md`](docs/diagramas/08-paquetes.md) |
| Componentes | [`09-componentes.md`](docs/diagramas/09-componentes.md) |
| Despliegue | [`10-despliegue.md`](docs/diagramas/10-despliegue.md) |
| Base de datos | [`11-base-de-datos.md`](docs/diagramas/11-base-de-datos.md) |

## Base de datos

El esquema relacional está organizado para que las clases principales tengan correspondencia con las tablas. Las claves foráneas representan las relaciones y se incluyen restricciones de unicidad e integridad.

- [`database/schema.sql`](database/schema.sql)

## Estructura del repositorio

```text
gestion-flota/
├── README.md
├── database/
│   └── schema.sql
├── docs/
│   └── diagramas/
│       ├── 01-casos-de-uso.md
│       ├── 02-actividades.md
│       ├── 03-clases.md
│       ├── 04-objetos.md
│       ├── 05-estados.md
│       ├── 06-secuencia-asignacion.md
│       ├── 07-secuencia-inspeccion.md
│       ├── 08-paquetes.md
│       ├── 09-componentes.md
│       ├── 10-despliegue.md
│       └── 11-base-de-datos.md
├── src/
│   └── flota.py
└── tests/
    └── test_flota.py
```

## Tecnologías

- Python 3.10+
- MySQL 8
- UML / Mermaid
- Programación Orientada a Objetos

## Cómo visualizarlo en GitHub

Abre `README.md` o cualquiera de los archivos de `docs/diagramas/`. GitHub renderiza automáticamente los bloques Mermaid.

## GitDiagram

El repositorio también mantiene el modelo en **Python** y **SQL**, no solamente como imágenes. Esto permite que una herramienta de análisis del repositorio pueda detectar clases, módulos, dependencias y tablas a partir de archivos reales.

Los diagramas Mermaid son la representación visual para GitHub; `src/flota.py` y `database/schema.sql` son la fuente estructural para el análisis del repositorio.
