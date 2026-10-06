from datetime import date, timedelta
import unittest
from src.flota import Vehiculo, TipoVehiculo, EstadoVehiculo, Conductor, Inspeccion, ResultadoInspeccion, Asignacion

class TestFlota(unittest.TestCase):
    def setUp(self):
        tipo = TipoVehiculo('Camioneta 4x4', 'Liviano', 'KM')
        self.vehiculo = Vehiculo('CMT-001', 'AQX-725', tipo)
        self.conductor = Conductor('41111111', 'Juan Pérez', 'Q41111111', date.today() + timedelta(days=30))
        self.inspeccion = Inspeccion(self.vehiculo, date.today(), [])
        self.inspeccion.resultado = ResultadoInspeccion.APTO

    def test_asignacion_cambia_estado(self):
        Asignacion(self.vehiculo, self.conductor, self.inspeccion).registrar()
        self.assertEqual(self.vehiculo.estado, EstadoVehiculo.ASIGNADO)

    def test_no_asignar_sin_inspeccion_apta(self):
        self.inspeccion.resultado = ResultadoInspeccion.NO_APTO
        with self.assertRaises(ValueError):
            Asignacion(self.vehiculo, self.conductor, self.inspeccion).registrar()

if __name__ == '__main__':
    unittest.main()
