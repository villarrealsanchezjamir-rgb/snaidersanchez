# Diagrama de casos de uso

```mermaid
flowchart LR
    Admin[Administrador]
    Trans[Encargado de transporte]
    Mant[Encargado de mantenimiento]
    HSE[Supervisor de seguridad HSE]
    Ger[Gerencia]
    Reloj[Reloj del sistema]

    subgraph Sistema["Sistema Integral de Gestión de Flota Vehicular"]
      CU1((CU-01 Iniciar sesión))
      CU2((CU-02 Gestionar usuarios y roles))
      CU3((CU-03 Gestionar flota y conductores))
      CU4((CU-04 Registrar asignación))
      CU5((CU-05 Verificar disponibilidad y licencia))
      CU6((CU-06 Registrar alquiler))
      CU7((CU-07 Registrar consumo de combustible))
      CU8((CU-08 Registrar mantenimiento))
      CU9((CU-09 Gestionar documentación vehicular))
      CU10((CU-10 Registrar inspección preoperacional))
      CU11((CU-11 Registrar incidente))
      CU12((CU-12 Consultar dashboard e indicadores))
      CU13((CU-13 Generar reportes))
      CU14((CU-14 Consultar historial del vehículo))
      CU15((CU-15 Generar alertas de vencimiento))
    end

    Admin --> CU1 & CU2 & CU3
    Trans --> CU1 & CU4 & CU6 & CU7
    Mant --> CU1 & CU8 & CU9 & CU14
    HSE --> CU1 & CU10 & CU11 & CU12
    Ger --> CU1 & CU12 & CU13
    Reloj --> CU15
    CU4 -. incluye .-> CU5
    CU6 -. incluye .-> CU5
```
