"""Modelo de dominio de referencia del Sistema Integral de Gestión de Flota Vehicular."""
from abc import ABC, abstractmethod
from dataclasses import dataclass
from datetime import date
from enum import Enum
from typing import Protocol

class EstadoVehiculo(Enum):
    DISPONIBLE = "DISPONIBLE"
    ASIGNADO = "ASIGNADO"
    ALQUILADO = "ALQUILADO"
    EN_MANTENIMIENTO = "EN_MANTENIMIENTO"
    FUERA_DE_SERVICIO = "FUERA_DE_SERVICIO"
    DADO_DE_BAJA = "DADO_DE_BAJA"

class ResultadoInspeccion(Enum):
    APTO = "APTO"
    APTO_CON_OBSERVACIONES = "APTO_CON_OBSERVACIONES"
    NO_APTO = "NO_APTO"

class Auditable(Protocol):
    def generar_evento(self): ...

class Vencible(Protocol):
    def fecha_limite(self) -> date: ...
    def dias_para_vencer(self, hoy: date) -> int: ...

@dataclass
class Empresa:
    razon_social: str
    ruc: str

@dataclass
class UnidadMinera:
    nombre: str
    empresa: Empresa

@dataclass
class Area:
    nombre: str
    unidad_minera: UnidadMinera

@dataclass
class TipoVehiculo:
    nombre: str
    categoria: str
    unidad_medicion: str

@dataclass
class Vehiculo:
    codigo_interno: str
    placa: str | None
    tipo: TipoVehiculo
    area: Area | None = None
    kilometraje: float = 0
    estado: EstadoVehiculo = EstadoVehiculo.DISPONIBLE

    def esta_disponible(self):
        return self.estado == EstadoVehiculo.DISPONIBLE

    def cambiar_estado(self, estado):
        self.estado = estado

@dataclass
class Conductor:
    dni: str
    nombre: str
    licencia: str
    vencimiento_licencia: date

    def licencia_vigente(self, hoy: date):
        return self.vencimiento_licencia >= hoy

class OperacionVehiculo(ABC):
    """Clase abstracta común para operaciones sobre vehículos."""
    def __init__(self, vehiculo, conductor, inspeccion=None):
        self.vehiculo = vehiculo
        self.conductor = conductor
        self.inspeccion = inspeccion

    @abstractmethod
    def validar(self): ...

    def registrar(self):
        if not self.vehiculo.esta_disponible():
            raise ValueError("Vehículo no disponible")
        self.validar()

class Asignacion(OperacionVehiculo):
    def validar(self):
        if self.inspeccion is None or not self.inspeccion.es_apta():
            raise ValueError("Falta inspección APTO")
        self.vehiculo.cambiar_estado(EstadoVehiculo.ASIGNADO)

class Alquiler(OperacionVehiculo):
    def validar(self):
        if self.inspeccion is None or not self.inspeccion.es_apta():
            raise ValueError("Falta inspección APTO")
        self.vehiculo.cambiar_estado(EstadoVehiculo.ALQUILADO)

@dataclass
class TipoMantenimiento:
    nombre: str
    es_preventivo: bool
    frecuencia_km: int | None = None
    frecuencia_horas: int | None = None
    frecuencia_dias: int | None = None

@dataclass
class Mantenimiento:
    vehiculo: Vehiculo
    tipo: TipoMantenimiento
    fecha: date
    costo: float
    proxima_fecha: date | None = None

@dataclass
class TipoDocumento:
    nombre: str
    requiere_vencimiento: bool
    dias_alerta: int

@dataclass
class DocumentoVehiculo:
    vehiculo: Vehiculo
    tipo: TipoDocumento
    fecha_vencimiento: date | None

@dataclass
class DetalleInspeccion:
    item: str
    conforme: bool
    critico: bool = False

@dataclass
class Inspeccion:
    vehiculo: Vehiculo
    fecha: date
    detalles: list[DetalleInspeccion]
    resultado: ResultadoInspeccion | None = None

    def agregar_detalle(self, detalle):
        self.detalles.append(detalle)

    def es_apta(self):
        return self.resultado in (ResultadoInspeccion.APTO, ResultadoInspeccion.APTO_CON_OBSERVACIONES)

@dataclass
class Combustible:
    vehiculo: Vehiculo
    cantidad: float
    precio_unitario: float
    fecha: date

@dataclass
class Incidente:
    vehiculo: Vehiculo
    conductor: Conductor
    tipo: str
    fecha: date
    descripcion: str

@dataclass
class HistorialVehiculo:
    vehiculo: Vehiculo
    eventos: list[str]

@dataclass
class Rol:
    nombre: str
    descripcion: str

@dataclass
class Usuario:
    nombre_usuario: str
    rol: Rol
    nombre: str
