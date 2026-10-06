# Diagrama de clases — modelo completo

El modelo contiene 19 clases de dominio. `OperacionVehiculo` es una clase abstracta de diseño y `Auditable`/`Vencible` son interfaces de diseño.

```mermaid
classDiagram
    class Empresa
    class UnidadMinera
    class Area
    class TipoVehiculo
    class Vehiculo {
      -kilometraje
      -estado
      +cambiarEstado()
      +actualizarLectura()
      +estaDisponible()
    }
    class Conductor {
      +licenciaVigente()
    }
    class OperacionVehiculo {
      <<abstract>>
      #vehiculo
      #conductor
      #inspeccion
      +registrar()
      +finalizar()
      +validar()
    }
    class Asignacion
    class Alquiler
    class TipoMantenimiento
    class Mantenimiento
    class TipoDocumento
    class DocumentoVehiculo
    class Inspeccion
    class DetalleInspeccion
    class Combustible
    class Incidente
    class HistorialVehiculo
    class Rol
    class Usuario
    class Auditable {
      <<interface>>
      +generarEvento()
    }
    class Vencible {
      <<interface>>
      +fechaLimite()
      +diasParaVencer()
    }

    Empresa "1" *-- "0..*" UnidadMinera
    UnidadMinera "1" *-- "0..*" Area
    Area "1" o-- "0..*" Vehiculo
    TipoVehiculo "1" --> "0..*" Vehiculo
    Vehiculo "1" --> "0..*" Asignacion
    Vehiculo "1" --> "0..*" Alquiler
    Conductor "1" --> "0..*" Asignacion
    Conductor "1" --> "0..*" Alquiler
    Area "1" --> "0..*" Asignacion
    TipoMantenimiento "1" --> "0..*" Mantenimiento
    Vehiculo "1" --> "0..*" Mantenimiento
    Vehiculo "1" *-- "0..*" DocumentoVehiculo
    TipoDocumento "1" --> "0..*" DocumentoVehiculo
    Vehiculo "1" --> "0..*" Inspeccion
    Inspeccion "1" *-- "1..*" DetalleInspeccion
    Vehiculo "1" --> "0..*" Combustible
    Vehiculo "1" --> "0..*" Incidente
    Conductor "1" --> "0..*" Incidente
    Vehiculo "1" *-- "0..*" HistorialVehiculo
    Rol "1" o-- "1..*" Usuario
    Usuario "1" --> "0..*" Inspeccion
    Usuario "1" --> "0..*" Combustible
    Usuario "1" --> "0..*" HistorialVehiculo

    OperacionVehiculo <|-- Asignacion
    OperacionVehiculo <|-- Alquiler
    Auditable <|.. Inspeccion
    Auditable <|.. Combustible
    Auditable <|.. Incidente
    Auditable <|.. Asignacion
    Auditable <|.. Alquiler
    Vencible <|.. DocumentoVehiculo
    Vencible <|.. Conductor
    Vencible <|.. Mantenimiento
```

### Leyenda

- `*--` composición: la parte depende del ciclo de vida del todo.
- `o--` agregación: la parte puede existir y reasignarse independientemente.
- `-->` asociación.
- `<|--` herencia.
- `<<interface>>` contrato de comportamiento.
