# 🏙️ Cidade Inteligente — Flutter App

Aplicativo mobile para denúncias urbanas e comunicação entre moradores, prefeitura e empresas responsáveis.

---

## 📱 Telas implementadas

| # | Tela | Arquivo |
|---|------|---------|
| 1 | Login e Cadastro | `lib/screens/auth/` |
| 2 | Seleção de Área | `lib/screens/area/` |
| 3 | Feed (Tela Inicial) | `lib/screens/home/` |
| 4 | Criar Denúncia | `lib/screens/denuncia/criar_denuncia_screen.dart` |
| 5 | Detalhes da Denúncia | `lib/screens/denuncia/detalhe_denuncia_screen.dart` |
| 6 | Chat de Suporte | `lib/screens/chat/chat_screen.dart` |
| 7 | Histórico de Chats | `lib/screens/chat/historico_chats_screen.dart` |
| 8 | Notificações | `lib/screens/notificacoes/` |
| 9 | Perfil | `lib/screens/perfil/` |
| 10 | Painel do Funcionário | `lib/screens/funcionario/` |

---

## 🗂️ Estrutura do projeto

```
lib/
├── main.dart                          # Entrada do app + providers
├── theme/
│   └── app_theme.dart                 # Material Design 3, cores, tipografia
├── models/
│   └── models.dart                    # Modelos de dados + Mock Data
├── controllers/
│   └── app_controller.dart            # AuthController, DenunciaController, ChatController, NotificacaoController
├── routes/
│   └── app_router.dart                # Navegação com GoRouter
├── widgets/
│   └── widgets.dart                   # Widgets reutilizáveis
└── screens/
    ├── auth/
    │   ├── login_screen.dart
    │   └── cadastro_screen.dart
    ├── area/
    │   └── selecao_area_screen.dart
    ├── home/
    │   ├── home_shell.dart            # BottomNavigationBar shell
    │   └── feed_screen.dart
    ├── denuncia/
    │   ├── criar_denuncia_screen.dart
    │   └── detalhe_denuncia_screen.dart
    ├── chat/
    │   ├── chat_screen.dart
    │   └── historico_chats_screen.dart
    ├── notificacoes/
    │   └── notificacoes_screen.dart
    ├── perfil/
    │   └── perfil_screen.dart
    └── funcionario/
        └── painel_funcionario_screen.dart
```

---

## 🚀 Como rodar

### Pré-requisitos
- Flutter SDK 3.x
- Android Studio ou VS Code com extensão Flutter
- Dispositivo Android ou emulador

### Instalação

```bash
# 1. Clone ou extraia o projeto
cd cidade_inteligente

# 2. Instale as dependências
flutter pub get

# 3. Crie as pastas de assets
mkdir -p assets/images assets/icons

# 4. Rode o app
flutter run
```

---

## 🔐 Credenciais de teste (mock)

| Tipo | Email | Senha |
|------|-------|-------|
| **Morador** | qualquer@email.com | 123456 |
| **Funcionário** | nome@prefeitura.gov.br | 123456 |

> O sistema detecta automaticamente o perfil pelo domínio do email.

---

## 🧩 Dependências principais

| Pacote | Uso |
|--------|-----|
| `go_router` | Navegação declarativa |
| `provider` | Gerenciamento de estado |
| `image_picker` | Seleção de fotos |
| `cached_network_image` | Cache de imagens |
| `badges` | Badges no BottomNav |
| `shimmer` | Loading skeleton |
| `intl` | Formatação de datas |

---

## 🔧 Próximos passos (backend)

- [ ] Integrar Firebase Auth (substituir `AuthController` mock)
- [ ] Integrar Firestore para denúncias em tempo real
- [ ] Firebase Storage para upload de fotos
- [ ] Firebase Cloud Messaging para notificações push
- [ ] Google Maps para localização das denúncias
- [ ] Integrar `image_picker` na tela de criar denúncia
- [ ] Sistema de comentários nas denúncias
- [ ] Filtro por raio de distância (geolocalização)

---

## 💡 Sugestões de melhoria

1. **Mapa interativo** — Exibir denúncias em mapa (google_maps_flutter)
2. **Offline first** — Cache local com Hive ou SQLite para funcionar sem internet
3. **Dark mode** — Adicionar tema escuro (já preparado no AppTheme)
4. **Acessibilidade** — Aumentar suporte a leitores de tela
5. **Gamificação** — Pontuação para moradores engajados
6. **Relatórios** — Dashboard para gestores com gráficos de tendências

---

*Gerado como frontend Flutter com mock data. Substitua os controllers por chamadas reais de API.*
