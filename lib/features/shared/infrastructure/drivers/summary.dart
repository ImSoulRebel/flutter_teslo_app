/*
 ╔══════════════════════════════════════════════════════════════════════════════════════╗
 ║                          PATRÓN ADAPTADOR SIMPLE PARA DIO                           ║
 ╚══════════════════════════════════════════════════════════════════════════════════════╝
 
 📁 Estructura Creada:
 
    shared/infrastructure/
    ├── adapters/
    │   ├── 🔌 http_adapter.dart              # Interfaz HTTP simple
    │   └── 💾 storage_adapter.dart           # Interfaz de almacenamiento simple
    ├── implementations/
    │   ├── 🌐 dio_adapter.dart               # Implementación con DIO
    │   └── 📱 shared_preferences_storage_adapter.dart  # Implementación con SharedPreferences
    ├── examples/
    │   └── 📖 simple_adapter_examples.dart   # Ejemplos de uso práctico
    ├── 📦 simple_adapters.dart               # Exportaciones
    └── 📚 SIMPLE_ADAPTER_README.md           # Documentación completa

 🎯 Qué logramos:

 ✅ ENCAPSULACIÓN
    • DIO está completamente oculto del dominio
    • SharedPreferences no se ve en la lógica de negocio
    • Interfaces simples y claras

 ✅ FLEXIBILIDAD  
    • Fácil cambio entre implementaciones
    • Configuración automática de tokens
    • Headers y timeouts preconfigurados

 ✅ TESTABILIDAD
    • Mocks simples para testing
    • Interfaces mínimas pero completas
    • Inyección de dependencias sencilla

 ✅ SIMPLICIDAD
    • Solo ~200 líneas de código total
    • 2 interfaces principales
    • Configuración automática

 🔧 Uso en AuthDatasourceImpl:

    final httpClient = DioAdapter(baseUrl: 'https://teslo-api.herokuapp.com/api');
    final storage = SharedPreferencesStorageAdapter();

    // Login automático con token
    final user = await httpClient.post('/auth/login', {...});
    await storage.saveToken(user['token']);
    httpClient.setAuthToken(user['token']); // Auto-config para futuras peticiones

 🧪 Testing Made Easy:

    final mockHttp = MockHttpAdapter();
    final mockStorage = MockStorageAdapter();
    final dataSource = AuthDatasourceImpl(
      httpClient: mockHttp,
      storage: mockStorage,
    );

 💡 Cuándo usar este patrón:
    ✓ Aplicaciones con necesidades HTTP básicas
    ✓ Equipos que prefieren simplicidad
    ✓ Desarrollo rápido y mantenible
    ✓ 90% de casos de uso reales
*/
